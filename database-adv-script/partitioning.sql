-- First, let's create a backup of the existing bookings table
CREATE TABLE booking_backup AS SELECT * FROM booking;

-- Drop the current booking table to recreate it with partitioning
DROP TABLE IF EXISTS booking;

-- Create the new booking table with RANGE partitioning based on start_date
CREATE TABLE `booking` (
    `booking_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `property_id` CHAR(36) NOT NULL,
    `user_id` CHAR(36) NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `total_price` DECIMAL(10, 2) NOT NULL,
    `status` ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX `idx_booking_property_id` (`property_id`),
    INDEX `idx_booking_user_id` (`user_id`),
    INDEX `idx_booking_date_range` (`start_date`, `end_date`),
    INDEX `idx_booking_status` (`status`),
    
    CONSTRAINT `fk_booking_property_id`
        FOREIGN KEY (`property_id`)
        REFERENCES `property` (`property_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_booking_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `user` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    PARTITION p_before_2024 VALUES LESS THAN (202401),
    PARTITION p_2024_q1 VALUES LESS THAN (202404),
    PARTITION p_2024_q2 VALUES LESS THAN (202407),
    PARTITION p_2024_q3 VALUES LESS THAN (202410),
    PARTITION p_2024_q4 VALUES LESS THAN (202501),
    PARTITION p_2025_q1 VALUES LESS THAN (202504),
    PARTITION p_2025_q2 VALUES LESS THAN (202507),
    PARTITION p_2025_q3 VALUES LESS THAN (202510),
    PARTITION p_2025_q4 VALUES LESS THAN (202601),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Restore data from the backup table
INSERT INTO booking SELECT * FROM booking_backup;

-- Add validation triggers for the partitioned table
DELIMITER //

-- Ensure booking dates are valid and price is non-negative
CREATE TRIGGER before_booking_insert_partitioned
BEFORE INSERT ON booking
FOR EACH ROW
BEGIN
    IF NEW.end_date <= NEW.start_date THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'End date must be after start date';
    END IF;
    
    IF NEW.total_price < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Total price must be non-negative';
    END IF;
END//

CREATE TRIGGER before_booking_update_partitioned
BEFORE UPDATE ON booking
FOR EACH ROW
BEGIN
    IF NEW.end_date <= NEW.start_date THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'End date must be after start date';
    END IF;
    
    IF NEW.total_price < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Total price must be non-negative';
    END IF;
END//

DELIMITER ;

-- Test queries to compare performance before and after partitioning

-- Query 1: Find bookings for Q1 2025 (January-March)
-- Before partitioning
EXPLAIN ANALYZE
SELECT * FROM booking_backup
WHERE start_date >= '2025-01-01' AND start_date < '2025-04-01'
ORDER BY start_date;

-- After partitioning
EXPLAIN ANALYZE
SELECT * FROM booking
WHERE start_date >= '2025-01-01' AND start_date < '2025-04-01'
ORDER BY start_date;

-- Query 2: Find bookings for a specific property in Q2 2025
-- Before partitioning
EXPLAIN ANALYZE
SELECT 
    b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
    u.first_name, u.last_name, u.email
FROM 
    booking_backup b
JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.property_id = 'sample_property_id' -- Replace with actual property ID for testing
    AND b.start_date >= '2025-04-01' 
    AND b.start_date < '2025-07-01';

-- After partitioning
EXPLAIN ANALYZE
SELECT 
    b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
    u.first_name, u.last_name, u.email
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
WHERE 
    b.property_id = 'sample_property_id' -- Replace with actual property ID for testing
    AND b.start_date >= '2025-04-01' 
    AND b.start_date < '2025-07-01';

-- Query 3: Count bookings by status across multiple quarters
-- Before partitioning
EXPLAIN ANALYZE
SELECT 
    YEAR(start_date) AS booking_year,
    QUARTER(start_date) AS booking_quarter,
    status,
    COUNT(*) AS booking_count
FROM 
    booking_backup
WHERE 
    start_date >= '2024-01-01' AND start_date < '2026-01-01'
GROUP BY 
    YEAR(start_date), QUARTER(start_date), status
ORDER BY 
    booking_year, booking_quarter, status;

-- After partitioning
EXPLAIN ANALYZE
SELECT 
    YEAR(start_date) AS booking_year,
    QUARTER(start_date) AS booking_quarter,
    status,
    COUNT(*) AS booking_count
FROM 
    booking
WHERE 
    start_date >= '2024-01-01' AND start_date < '2026-01-01'
GROUP BY 
    YEAR(start_date), QUARTER(start_date), status
ORDER BY 
    booking_year, booking_quarter, status;

-- Cleanup (if needed during testing)
-- DROP TABLE IF EXISTS booking_backup;