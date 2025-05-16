-- Query performance BEFORE adding indexes
-- Test Query 1: Find available properties in a specific location and price range
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.price_per_night
FROM property p
WHERE p.location LIKE '%New York%'
  AND p.price_per_night BETWEEN 100 AND 300
  AND p.property_id NOT IN (
      SELECT b.property_id
      FROM booking b
      WHERE b.status = 'confirmed'
        AND (b.start_date <= '2025-06-15' AND b.end_date >= '2025-06-10')
  )
ORDER BY p.price_per_night ASC;

-- Test Query 2: Find top-rated properties with confirmed bookings
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) AS avg_rating,
       COUNT(DISTINCT b.booking_id) AS booking_count
FROM property p
JOIN review r ON p.property_id = r.property_id
JOIN booking b ON p.property_id = b.property_id
WHERE b.status = 'confirmed'
GROUP BY p.property_id, p.name, p.location
HAVING AVG(r.rating) >= 4.0
ORDER BY avg_rating DESC, booking_count DESC
LIMIT 10;

-- Test Query 3: Find users with confirmed bookings in a date range
EXPLAIN ANALYZE
SELECT u.user_id, CONCAT(u.first_name, ' ', u.last_name) AS user_name, 
       COUNT(b.booking_id) AS booking_count
FROM user u
JOIN booking b ON u.user_id = b.user_id
WHERE u.role = 'guest'
  AND b.status = 'confirmed'
  AND b.start_date >= '2025-01-01'
  AND b.start_date <= '2025-12-31'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY booking_count DESC;

-- Create indexes for optimization
-- User table indexes
-- Primary key already indexed by default
-- Email is commonly used for lookups and is already uniquely indexed
-- Role is used for filtering users by type (guest, host, admin)
CREATE INDEX idx_user_role ON user(role);

-- Property table indexes
-- Primary key and host_id are already indexed
-- Location is frequently used in filtering and searching
CREATE INDEX idx_property_location ON property(location);
-- Price range searches are common
CREATE INDEX idx_property_price ON property(price_per_night);
-- Combined index for location and price (for location + price range queries)
CREATE INDEX idx_property_location_price ON property(location, price_per_night);

-- Booking table indexes
-- Primary key, property_id, and user_id are already indexed
-- Start_date and end_date are already covered by composite index idx_booking_date_range
-- Status is frequently used for filtering bookings
CREATE INDEX idx_booking_status ON booking(status);
-- Combined index for property and status (for property's booking status)
CREATE INDEX idx_booking_property_status ON booking(property_id, status);
-- Combined index for user and status (for user's booking status)
CREATE INDEX idx_booking_user_status ON booking(user_id, status);
-- Combined index for status and date range (common filtering pattern)
CREATE INDEX idx_booking_status_dates ON booking(status, start_date, end_date);

-- Review table indexes
-- Primary key, property_id, and user_id are already indexed
-- Rating is used for filtering and sorting
CREATE INDEX idx_review_rating ON review(rating);
-- Combined index for property and rating (for property's rating filters)
CREATE INDEX idx_review_property_rating ON review(property_id, rating);

-- Payment table indexes
-- Primary key and booking_id are already indexed
-- Payment method is used for filtering
CREATE INDEX idx_payment_method ON payment(payment_method);
-- Payment date is used for filtering and reporting
CREATE INDEX idx_payment_date ON payment(payment_date);
-- Combined index for method and date (for payment method reporting)
CREATE INDEX idx_payment_method_date ON payment(payment_method, payment_date);

-- Query performance AFTER adding indexes
-- Test Query 1: Find available properties in a specific location and price range
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.price_per_night
FROM property p
WHERE p.location LIKE '%New York%'
  AND p.price_per_night BETWEEN 100 AND 300
  AND p.property_id NOT IN (
      SELECT b.property_id
      FROM booking b
      WHERE b.status = 'confirmed'
        AND (b.start_date <= '2025-06-15' AND b.end_date >= '2025-06-10')
  )
ORDER BY p.price_per_night ASC;

-- Test Query 2: Find top-rated properties with confirmed bookings
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, 
       AVG(r.rating) AS avg_rating,
       COUNT(DISTINCT b.booking_id) AS booking_count
FROM property p
JOIN review r ON p.property_id = r.property_id
JOIN booking b ON p.property_id = b.property_id
WHERE b.status = 'confirmed'
GROUP BY p.property_id, p.name, p.location
HAVING AVG(r.rating) >= 4.0
ORDER BY avg_rating DESC, booking_count DESC
LIMIT 10;

-- Test Query 3: Find users with confirmed bookings in a date range
EXPLAIN ANALYZE
SELECT u.user_id, CONCAT(u.first_name, ' ', u.last_name) AS user_name, 
       COUNT(b.booking_id) AS booking_count
FROM user u
JOIN booking b ON u.user_id = b.user_id
WHERE u.role = 'guest'
  AND b.status = 'confirmed'
  AND b.start_date >= '2025-01-01'
  AND b.start_date <= '2025-12-31'
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY booking_count DESC;