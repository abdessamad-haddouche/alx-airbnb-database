-- Non-correlated subquery: Find all properties where the average rating is greater than 4.0
SELECT p.property_id, p.name, p.location, p.price_per_night, 
       (SELECT AVG(r.rating) FROM review r WHERE r.property_id = p.property_id) AS avg_rating
FROM property p
WHERE p.property_id IN (
    SELECT r.property_id 
    FROM review r 
    GROUP BY r.property_id 
    HAVING AVG(r.rating) > 4.0
)
ORDER BY avg_rating DESC;

-- Alternative approach using a JOIN with a subquery
SELECT p.property_id, p.name, p.location, p.price_per_night, avg_ratings.avg_rating
FROM property p
JOIN (
    SELECT property_id, AVG(rating) AS avg_rating
    FROM review
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
) AS avg_ratings ON p.property_id = avg_ratings.property_id
ORDER BY avg_ratings.avg_rating DESC;

-- Correlated subquery: Find users who have made more than 3 bookings
SELECT u.user_id, u.first_name, u.last_name, u.email, u.role,
       (SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id) AS booking_count
FROM user u
WHERE (
    SELECT COUNT(*) 
    FROM booking b 
    WHERE b.user_id = u.user_id
) > 3
ORDER BY booking_count DESC;

-- Alternative approach using JOIN and GROUP BY
SELECT u.user_id, u.first_name, u.last_name, u.email, u.role, COUNT(b.booking_id) AS booking_count
FROM user u
JOIN booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email, u.role
HAVING COUNT(b.booking_id) > 3
ORDER BY booking_count DESC;