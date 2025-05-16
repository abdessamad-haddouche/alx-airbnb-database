-- 4. Optimize Complex Queries

-- Initial complex query to retrieve all bookings with user, property, and payment details
-- This query joins multiple tables and retrieves comprehensive information

-- Initial query (before optimization)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.price_per_night,
    p.created_at AS property_created_at,
    
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method,
    
    (SELECT COUNT(*) FROM review r WHERE r.property_id = p.property_id) AS review_count,
    (SELECT AVG(rating) FROM review r WHERE r.property_id = p.property_id) AS avg_rating
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    b.start_date DESC;

-- Optimized query - Version 1
-- Removing unnecessary subqueries and using more efficient joins
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.price_per_night,
    p.created_at AS property_created_at,
    
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method,
    
    review_stats.review_count,
    review_stats.avg_rating
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN (
    SELECT 
        property_id, 
        COUNT(*) AS review_count,
        AVG(rating) AS avg_rating
    FROM 
        review
    GROUP BY 
        property_id
) AS review_stats ON p.property_id = review_stats.property_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    b.start_date DESC;

-- Optimized query - Version 2
-- Using EXISTS instead of COUNT for more efficient filtering
-- Using LIMIT for pagination to reduce result set size
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    p.property_id,
    p.name AS property_name,
    p.location,
    p.price_per_night,
    
    pay.payment_id,
    pay.amount,
    pay.payment_method
FROM 
    booking b
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date > '2025-01-01'  -- Date filtering reduces result set
ORDER BY 
    b.start_date DESC
LIMIT 100; -- Pagination for better performance

-- Optimized query - Final version
-- Using covering indexes and limiting columns to only what's necessary
-- Adding STRAIGHT_JOIN hint to enforce join order
EXPLAIN ANALYZE
SELECT STRAIGHT_JOIN
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    
    p.property_id,
    p.name AS property_name,
    p.location,
    p.price_per_night,
    
    pay.payment_id,
    pay.amount,
    pay.payment_method
FROM 
    booking b
    USE INDEX (idx_booking_status)
JOIN 
    user u ON b.user_id = u.user_id
JOIN 
    property p ON b.property_id = p.property_id
LEFT JOIN 
    payment pay ON b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
    AND b.start_date BETWEEN '2025-01-01' AND '2025-12-31'  -- Using BETWEEN for better index usage
ORDER BY 
    b.start_date DESC
LIMIT 100;