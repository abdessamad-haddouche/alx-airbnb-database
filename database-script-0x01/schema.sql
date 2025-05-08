-- AirBnB Database Schema for MySQL

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
    `price_per_night` DECIMAL(10, 2) NOT NULL CHECK (`price_per_night` > 0),
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
    `end_date` DATE NOT NULL CHECK (`end_date` > `start_date`),
    `total_price` DECIMAL(10, 2) NOT NULL CHECK (`total_price` >= 0),
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
    `amount` DECIMAL(10, 2) NOT NULL CHECK (`amount` > 0),
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
    `rating` INT NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
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