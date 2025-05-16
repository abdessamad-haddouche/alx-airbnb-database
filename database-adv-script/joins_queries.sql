-- Complex Queries with Joins

-- INNER JOIN - Retrieve all bookings and respective users who made those bookings
SELECT b.booking_id, b.property_id, b.start_date, b.end_date, b.total_price, b.status,
       u.user_id, u.first_name, u.last_name, u.email, u.role
FROM booking b
INNER JOIN user u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- LEFT JOIN - Retrieve all properties and their reviews, including properties without reviews
SELECT p.property_id, p.name, p.description, p.location, p.price_per_night,
       r.review_id, r.rating, r.comment, r.created_at AS review_date,
       u.first_name AS reviewer_first_name, u.last_name AS reviewer_last_name
FROM property p
LEFT JOIN review r ON p.property_id = r.property_id
LEFT JOIN user u ON r.user_id = u.user_id
ORDER BY p.property_id, r.created_at DESC;

-- FULL OUTER JOIN (Emulated with UNION in MySQL) - Retrieve all users and bookings
SELECT u.user_id, u.first_name, u.last_name, u.email, u.role,
       b.booking_id, b.property_id, b.start_date, b.end_date, b.status
FROM user u
LEFT JOIN booking b ON u.user_id = b.user_id

UNION

SELECT u.user_id, u.first_name, u.last_name, u.email, u.role,
       b.booking_id, b.property_id, b.start_date, b.end_date, b.status
FROM booking b
LEFT JOIN user u ON b.user_id = u.user_id
WHERE u.user_id IS NULL
ORDER BY user_id, booking_id;