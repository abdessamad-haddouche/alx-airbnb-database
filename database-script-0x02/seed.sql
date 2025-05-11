-- AirBnB Database Sample Data
-- This script populates the database with realistic sample data

-- Clear existing data (if any)
DELETE FROM message;
DELETE FROM review;
DELETE FROM payment;
DELETE FROM booking;
DELETE FROM property;
DELETE FROM user;

-- Seed Users
-- Format: first_name, last_name, email, password_hash, phone_number, role
INSERT INTO user (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
(UUID(), 'John', 'Smith', 'john.smith@example.com', '$2a$12$1HqSL198GW.DU6iwh/E9dedNgLA2kHl2zQCwQ3VLdP6KWoQlS3nwi', '+1-202-555-0123', 'host'),
(UUID(), 'Emma', 'Johnson', 'emma.johnson@example.com', '$2a$12$KP3oBVYgjOU4nOLQVOH/LuPOUdT2p1QSlCmjRhW10/V5tUcMi2vTy', '+1-202-555-0124', 'host'),
(UUID(), 'Michael', 'Williams', 'michael.williams@example.com', '$2a$12$FpgR3J7o9XyTFCXiLVHB0.Ou7q94gJj7qtMi8XSq9q.UqSQvcwbSW', '+1-202-555-0125', 'host'),
(UUID(), 'Sophia', 'Brown', 'sophia.brown@example.com', '$2a$12$YV5ZRmP0jVnMZrW5q3bZP.zA94IhnBB5M9JRuBtGcCuJgKJYbcFGO', '+1-202-555-0126', 'guest'),
(UUID(), 'James', 'Jones', 'james.jones@example.com', '$2a$12$ogOu7ZLzLZDXm8/TL9FKKegIUhTXeDhRrmGEJY.ShW2GGT0IGKE5m', '+1-202-555-0127', 'guest'),
(UUID(), 'Olivia', 'Garcia', 'olivia.garcia@example.com', '$2a$12$2a1Gihs9A6BRXcfAFQLZn.VJdDp8iJ70cQtP5Vz1MJJ9JwMxKZasm', '+1-202-555-0128', 'guest'),
(UUID(), 'William', 'Miller', 'william.miller@example.com', '$2a$12$FZoVwzw8c8Z4MUFzM.tHKuIKyWbpRQyn8GxTRbbWcO6C9wGpNyOqO', '+1-202-555-0129', 'guest'),
(UUID(), 'Ava', 'Davis', 'ava.davis@example.com', '$2a$12$dbMSvNMWMpzTx0QkKkiRmurO/xR81kpJhzPtRnH1hG8.DQiV3GJxa', '+1-202-555-0130', 'guest'),
(UUID(), 'Benjamin', 'Rodriguez', 'benjamin.rodriguez@example.com', '$2a$12$pPOK2C65t3WSBsQ8Z3HqueOGBqj32hM07ckJiN5yRZfXXrgBhO.gq', '+1-202-555-0131', 'admin'),
(UUID(), 'Charlotte', 'Martinez', 'charlotte.martinez@example.com', '$2a$12$5CjUMpK1Oi7jxuVqlfxn/.yLBAQhR2OYUnG3cXAKAOz8OKT9y1EuG', '+1-202-555-0132', 'guest');

-- Store user IDs for reference
SET @host1_id = (SELECT user_id FROM user WHERE email = 'john.smith@example.com');
SET @host2_id = (SELECT user_id FROM user WHERE email = 'emma.johnson@example.com');
SET @host3_id = (SELECT user_id FROM user WHERE email = 'michael.williams@example.com');
SET @guest1_id = (SELECT user_id FROM user WHERE email = 'sophia.brown@example.com');
SET @guest2_id = (SELECT user_id FROM user WHERE email = 'james.jones@example.com');
SET @guest3_id = (SELECT user_id FROM user WHERE email = 'olivia.garcia@example.com');
SET @guest4_id = (SELECT user_id FROM user WHERE email = 'william.miller@example.com');
SET @guest5_id = (SELECT user_id FROM user WHERE email = 'ava.davis@example.com');
SET @admin_id = (SELECT user_id FROM user WHERE email = 'benjamin.rodriguez@example.com');
SET @guest6_id = (SELECT user_id FROM user WHERE email = 'charlotte.martinez@example.com');

-- Seed Properties
-- Format: host_id, name, description, location, price_per_night
INSERT INTO property (property_id, host_id, name, description, location, price_per_night) VALUES
(UUID(), @host1_id, 'Luxury Beachfront Villa', 'Stunning beachfront villa with private pool and breathtaking ocean views. Perfect for family vacations.', 'Miami Beach, FL', 350.00),
(UUID(), @host1_id, 'Cozy Mountain Cabin', 'Charming log cabin nestled in the mountains. Features a fireplace and hot tub with forest views.', 'Aspen, CO', 175.00),
(UUID(), @host2_id, 'Modern Downtown Loft', 'Stylish loft in the heart of downtown. Walking distance to restaurants, shops, and attractions.', 'New York, NY', 225.00),
(UUID(), @host2_id, 'Rustic Farmhouse Retreat', 'Renovated farmhouse on 5 acres with organic garden. Perfect for a peaceful countryside getaway.', 'Vermont', 150.00),
(UUID(), @host3_id, 'Historic Brownstone', 'Beautifully restored 19th century brownstone with original features and modern amenities.', 'Boston, MA', 275.00),
(UUID(), @host3_id, 'Seaside Cottage', 'Quaint cottage just steps from the beach. Enjoy stunning sunsets from the private deck.', 'Cape Cod, MA', 195.00),
(UUID(), @host1_id, 'Desert Oasis', 'Modern home with private pool and spectacular desert views. Perfect for stargazing.', 'Scottsdale, AZ', 210.00),
(UUID(), @host2_id, 'Urban Treehouse', 'Unique treehouse-inspired apartment surrounded by trees in the city. A one-of-a-kind experience.', 'Portland, OR', 180.00),
(UUID(), @host3_id, 'Lakefront Cabin', 'Serene cabin on the lake with private dock. Canoe and fishing equipment included.', 'Lake Tahoe, CA', 230.00),
(UUID(), @host1_id, 'Penthouse Suite', 'Luxurious penthouse with panoramic city views, rooftop terrace, and high-end furnishings.', 'Chicago, IL', 400.00);

-- Store property IDs for reference
SET @property1_id = (SELECT property_id FROM property WHERE name = 'Luxury Beachfront Villa');
SET @property2_id = (SELECT property_id FROM property WHERE name = 'Cozy Mountain Cabin');
SET @property3_id = (SELECT property_id FROM property WHERE name = 'Modern Downtown Loft');
SET @property4_id = (SELECT property_id FROM property WHERE name = 'Rustic Farmhouse Retreat');
SET @property5_id = (SELECT property_id FROM property WHERE name = 'Historic Brownstone');
SET @property6_id = (SELECT property_id FROM property WHERE name = 'Seaside Cottage');
SET @property7_id = (SELECT property_id FROM property WHERE name = 'Desert Oasis');
SET @property8_id = (SELECT property_id FROM property WHERE name = 'Urban Treehouse');
SET @property9_id = (SELECT property_id FROM property WHERE name = 'Lakefront Cabin');
SET @property10_id = (SELECT property_id FROM property WHERE name = 'Penthouse Suite');

-- Seed Bookings
-- Format: property_id, user_id, start_date, end_date, total_price, status
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
(UUID(), @property1_id, @guest1_id, '2023-06-15', '2023-06-20', 1750.00, 'confirmed'),
(UUID(), @property2_id, @guest2_id, '2023-06-18', '2023-06-25', 1225.00, 'confirmed'),
(UUID(), @property3_id, @guest3_id, '2023-07-01', '2023-07-05', 900.00, 'confirmed'),
(UUID(), @property4_id, @guest4_id, '2023-07-10', '2023-07-15', 750.00, 'confirmed'),
(UUID(), @property5_id, @guest5_id, '2023-07-05', '2023-07-10', 1375.00, 'confirmed'),
(UUID(), @property6_id, @guest1_id, '2023-08-01', '2023-08-07', 1365.00, 'pending'),
(UUID(), @property7_id, @guest2_id, '2023-08-15', '2023-08-20', 1050.00, 'confirmed'),
(UUID(), @property8_id, @guest3_id, '2023-09-05', '2023-09-10', 900.00, 'canceled'),
(UUID(), @property9_id, @guest4_id, '2023-09-15', '2023-09-20', 1150.00, 'confirmed'),
(UUID(), @property10_id, @guest5_id, '2023-10-01', '2023-10-05', 1600.00, 'pending'),
(UUID(), @property1_id, @guest6_id, '2023-06-01', '2023-06-06', 1750.00, 'confirmed'),
(UUID(), @property2_id, @guest6_id, '2023-07-20', '2023-07-25', 875.00, 'confirmed'),
(UUID(), @property5_id, @guest3_id, '2023-08-10', '2023-08-15', 1375.00, 'confirmed'),
(UUID(), @property7_id, @guest1_id, '2023-07-25', '2023-07-28', 630.00, 'canceled'),
(UUID(), @property9_id, @guest2_id, '2023-11-10', '2023-11-15', 1150.00, 'pending');

-- Store booking IDs for reference
SET @booking1_id = (SELECT booking_id FROM booking WHERE property_id = @property1_id AND user_id = @guest1_id AND start_date = '2023-06-15');
SET @booking2_id = (SELECT booking_id FROM booking WHERE property_id = @property2_id AND user_id = @guest2_id AND start_date = '2023-06-18');
SET @booking3_id = (SELECT booking_id FROM booking WHERE property_id = @property3_id AND user_id = @guest3_id AND start_date = '2023-07-01');
SET @booking4_id = (SELECT booking_id FROM booking WHERE property_id = @property4_id AND user_id = @guest4_id AND start_date = '2023-07-10');
SET @booking5_id = (SELECT booking_id FROM booking WHERE property_id = @property5_id AND user_id = @guest5_id AND start_date = '2023-07-05');
SET @booking6_id = (SELECT booking_id FROM booking WHERE property_id = @property6_id AND user_id = @guest1_id AND start_date = '2023-08-01');
SET @booking7_id = (SELECT booking_id FROM booking WHERE property_id = @property7_id AND user_id = @guest2_id AND start_date = '2023-08-15');
SET @booking8_id = (SELECT booking_id FROM booking WHERE property_id = @property8_id AND user_id = @guest3_id AND start_date = '2023-09-05');
SET @booking9_id = (SELECT booking_id FROM booking WHERE property_id = @property9_id AND user_id = @guest4_id AND start_date = '2023-09-15');
SET @booking10_id = (SELECT booking_id FROM booking WHERE property_id = @property10_id AND user_id = @guest5_id AND start_date = '2023-10-01');
SET @booking11_id = (SELECT booking_id FROM booking WHERE property_id = @property1_id AND user_id = @guest6_id AND start_date = '2023-06-01');
SET @booking12_id = (SELECT booking_id FROM booking WHERE property_id = @property2_id AND user_id = @guest6_id AND start_date = '2023-07-20');
SET @booking13_id = (SELECT booking_id FROM booking WHERE property_id = @property5_id AND user_id = @guest3_id AND start_date = '2023-08-10');
SET @booking14_id = (SELECT booking_id FROM booking WHERE property_id = @property7_id AND user_id = @guest1_id AND start_date = '2023-07-25');
SET @booking15_id = (SELECT booking_id FROM booking WHERE property_id = @property9_id AND user_id = @guest2_id AND start_date = '2023-11-10');

-- Seed Payments
-- Format: booking_id, amount, payment_method
INSERT INTO payment (payment_id, booking_id, amount, payment_method) VALUES
(UUID(), @booking1_id, 1750.00, 'credit_card'),
(UUID(), @booking2_id, 1225.00, 'credit_card'),
(UUID(), @booking3_id, 900.00, 'paypal'),
(UUID(), @booking4_id, 750.00, 'credit_card'),
(UUID(), @booking5_id, 1375.00, 'stripe'),
(UUID(), @booking7_id, 1050.00, 'paypal'),
(UUID(), @booking9_id, 1150.00, 'credit_card'),
(UUID(), @booking11_id, 875.00, 'credit_card'),
(UUID(), @booking12_id, 875.00, 'paypal'),
(UUID(), @booking13_id, 1375.00, 'stripe'),
-- Partial payments for some bookings
(UUID(), @booking1_id, 500.00, 'credit_card'),
(UUID(), @booking4_id, 250.00, 'paypal'),
(UUID(), @booking7_id, 200.00, 'credit_card');

-- Seed Reviews
-- Format: property_id, user_id, rating, comment
INSERT INTO review (review_id, property_id, user_id, rating, comment) VALUES
(UUID(), @property1_id, @guest1_id, 5, 'Absolutely stunning property! The views are even better than in the photos. The host was very accommodating and the house was immaculate. Will definitely be back!'),
(UUID(), @property1_id, @guest6_id, 4, 'Beautiful place with amazing ocean views. The private pool was a highlight. Taking off one star because the air conditioning was a bit inconsistent.'),
(UUID(), @property2_id, @guest2_id, 5, 'Perfect mountain getaway! The cabin was cozy and had everything we needed. We loved the hot tub under the stars and the fireplace made evenings so special.'),
(UUID(), @property2_id, @guest6_id, 4, 'Lovely cabin in a beautiful setting. Well equipped kitchen and very comfortable beds. Slightly difficult to find at night though.'),
(UUID(), @property3_id, @guest3_id, 4, 'Great location in the heart of NYC. The loft is stylishly furnished and had all the amenities we needed. It can get a bit noisy at night, but that is city living!'),
(UUID(), @property4_id, @guest4_id, 5, 'This farmhouse was the perfect escape from city life. Peaceful, beautiful, and thoughtfully restored. We enjoyed fresh vegetables from the garden and long walks on the property.'),
(UUID(), @property5_id, @guest5_id, 5, 'Such a unique experience staying in this historic home. The renovation maintained the character while adding modern comforts. Location was perfect for exploring Boston.'),
(UUID(), @property5_id, @guest3_id, 3, 'The brownstone is beautiful and in a great location, but there were some maintenance issues during our stay. The host was responsive, but it affected our experience.'),
(UUID(), @property7_id, @guest2_id, 5, 'The desert house exceeded our expectations! Incredibly private, stunning architecture, and the pool was perfect for hot days. Stargazing at night was unforgettable.'),
(UUID(), @property9_id, @guest4_id, 4, 'Beautiful cabin with amazing lake views. The private dock was perfect for fishing and the provided canoe was a great touch. Kitchen could use some updating.');

-- Seed Messages
-- Format: sender_id, recipient_id, message_body
INSERT INTO message (message_id, sender_id, recipient_id, message_body) VALUES
-- Pre-booking inquiries
(UUID(), @guest1_id, @host1_id, 'Hi, I am interested in your Luxury Beachfront Villa. Is it available June 15-20? Also, is the pool heated?'),
(UUID(), @host1_id, @guest1_id, 'Hello! Yes, those dates are available. The pool is heated and maintained at a comfortable temperature year-round. Would you like to book?'),
(UUID(), @guest1_id, @host1_id, 'Great! Yes, I would like to proceed with booking for those dates. Is there anything specific I should know about the property?'),
(UUID(), @host1_id, @guest1_id, 'Wonderful! I have approved your booking request. The house has keyless entry - I will send you the code before your arrival. Let me know if you have any other questions!'),

(UUID(), @guest2_id, @host1_id, 'Hello, does your mountain cabin have good internet? I may need to work remotely during our stay.'),
(UUID(), @host1_id, @guest2_id, 'Hi there! Yes, we have high-speed fiber internet that works well for video calls and remote work. The download speed is around 100 Mbps.'),
(UUID(), @guest2_id, @host1_id, 'Perfect, thank you! I will go ahead with the booking.'),

-- During-stay communication
(UUID(), @guest3_id, @host2_id, 'Hi, we just checked in to the loft. Everything looks great, but we cannot figure out how to adjust the thermostat. Can you help?'),
(UUID(), @host2_id, @guest3_id, 'Welcome! Sorry about that confusion. The thermostat is behind the painting in the hallway (I know it is a bit hidden). Let me know if you need any other help!'),
(UUID(), @guest3_id, @host2_id, 'Found it, thank you! Also, do you have recommendations for good restaurants within walking distance?'),
(UUID(), @host2_id, @guest3_id, 'Glad you found it! For restaurants, I recommend "The Local Kitchen" (2 blocks north) for amazing farm-to-table food, and "Bella Notte" (3 blocks east) for Italian. Both are excellent!'),

-- Post-stay messages
(UUID(), @host3_id, @guest4_id, 'Thank you for staying at our farmhouse! We hope you enjoyed your stay. We would love it if you could leave a review sharing your experience.'),
(UUID(), @guest4_id, @host3_id, 'We had a wonderful time! The property was beautiful and exactly what we needed. I just left a 5-star review. We will definitely be back next year!'),

-- Problem resolution
(UUID(), @guest5_id, @host3_id, 'Hi, there seems to be an issue with the shower in the master bathroom. The water pressure is very low.'),
(UUID(), @host3_id, @guest5_id, 'I am so sorry about that! I will send our maintenance person over right away. Is 2pm today convenient for you?'),
(UUID(), @guest5_id, @host3_id, 'Yes, 2pm works fine. Thank you for the quick response!'),
(UUID(), @host3_id, @guest5_id, 'Great! Mike will be there at 2pm. He will call when he is on his way. Please let me know if you need anything else.'),
(UUID(), @guest5_id, @host3_id, 'The shower is fixed now. Thank you for addressing it so quickly!'),

-- Cancellation conversation
(UUID(), @guest3_id, @host2_id, 'I am very sorry, but I need to cancel my upcoming reservation at the Urban Treehouse due to a family emergency.'),
(UUID(), @host2_id, @guest3_id, 'I am so sorry to hear about your emergency. Of course, I understand. I have approved your cancellation request, and you should receive a refund according to our cancellation policy.'),
(UUID(), @guest3_id, @host2_id, 'Thank you for understanding. I hope to book with you another time.'),

-- Admin communication
(UUID(), @admin_id, @host1_id, 'Hello, this is from AirBnB support. We have received multiple outstanding reviews for your properties! We would like to feature your Beachfront Villa in our "Top Picks" collection.'),
(UUID(), @host1_id, @admin_id, 'That is wonderful news! I would be honored to have my property featured. Let me know if you need any additional information or photos.'),
(UUID(), @admin_id, @host1_id, 'Great! We will proceed with adding your property to the collection. This should increase your visibility and booking rate. Congratulations on your hosting success!');