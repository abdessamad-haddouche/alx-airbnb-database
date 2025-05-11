-- AirBnB Database Schema for MySQL (Compatible version)

-- Drop tables in reverse order to respect foreign key constraints
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS property;
DROP TABLE IF EXISTS user;

-- Table user
CREATE TABLE `user` (
    `user_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(20) DEFAULT NULL,
    `role` ENUM('guest', 'host', 'admin') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX `idx_user_email` (`email`)
);

-- Table property
CREATE TABLE `property` (
    `property_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `host_id` CHAR(36) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `location` VARCHAR(255) NOT NULL,
    `price_per_night` DECIMAL(10, 2) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX `idx_property_host_id` (`host_id`),

    CONSTRAINT `fk_property_host_id`
        FOREIGN KEY (`host_id`)
        REFERENCES `user` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table booking
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
);

-- Table payment
CREATE TABLE `payment` (
    `payment_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `booking_id` CHAR(36) NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `payment_method` ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    INDEX `idx_payment_booking_id` (`booking_id`),
    CONSTRAINT `fk_payment_booking_id`
        FOREIGN KEY (`booking_id`)
        REFERENCES `booking` (`booking_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table review
CREATE TABLE `review` (
    `review_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `property_id` CHAR(36) NOT NULL,
    `user_id` CHAR(36) NOT NULL,
    `rating` INT NOT NULL,
    `comment` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX `idx_review_property_id` (`property_id`),
    INDEX `idx_review_user_id` (`user_id`),

    CONSTRAINT `fk_review_property_id`
        FOREIGN KEY (`property_id`)
        REFERENCES `property` (`property_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_review_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `user` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table message
CREATE TABLE `message` (
    `message_id` CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    `sender_id` CHAR(36) NOT NULL,
    `recipient_id` CHAR(36) NOT NULL,
    `message_body` TEXT NOT NULL,
    `sent_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX `idx_message_sender_id` (`sender_id`),
    INDEX `idx_message_recipient_id` (`recipient_id`),
    INDEX `idx_message_conversation` (`sender_id`, `recipient_id`, `sent_at`),
    
    CONSTRAINT `fk_message_sender_id`
        FOREIGN KEY (`sender_id`)
        REFERENCES `user` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_message_recipient_id`
        FOREIGN KEY (`recipient_id`)
        REFERENCES `user` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Add validation triggers instead of CHECK constraints
DELIMITER //

-- Ensure property price is positive
CREATE TRIGGER before_property_insert
BEFORE INSERT ON property
FOR EACH ROW
BEGIN
    IF NEW.price_per_night <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Price per night must be positive';
    END IF;
END//

CREATE TRIGGER before_property_update
BEFORE UPDATE ON property
FOR EACH ROW
BEGIN
    IF NEW.price_per_night <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Price per night must be positive';
    END IF;
END//

-- Ensure booking dates are valid and price is non-negative
CREATE TRIGGER before_booking_insert
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

CREATE TRIGGER before_booking_update
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

-- Ensure payment amount is positive
CREATE TRIGGER before_payment_insert
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Payment amount must be positive';
    END IF;
END//

CREATE TRIGGER before_payment_update
BEFORE UPDATE ON payment
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Payment amount must be positive';
    END IF;
END//

-- Ensure rating is between 1 and 5
CREATE TRIGGER before_review_insert
BEFORE INSERT ON review
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END//

CREATE TRIGGER before_review_update
BEFORE UPDATE ON review
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END//

DELIMITER ;