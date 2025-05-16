# Index Performance Analysis

## High-Usage Columns Identification

After analyzing the database schema and common query patterns, the following high-usage columns were identified:

### User Table
- `role`: Used for filtering users by type (guest, host, admin)
- `email`: Already uniquely indexed

### Property Table
- `location`: Frequently used in search filters
- `price_per_night`: Used in price range searches
- `host_id`: Already indexed

### Booking Table
- `status`: Used for filtering bookings
- `start_date` and `end_date`: Already indexed with a composite index

---

## Index Creation

Based on the identified high-usage columns, the following indexes were created:

```sql
-- User table indexes
CREATE INDEX idx_user_role ON user(role);

-- Property table indexes
CREATE INDEX idx_property_location ON property(location);
CREATE INDEX idx_property_price ON property(price_per_night);
CREATE INDEX idx_property_location_price ON property(location, price_per_night);

-- Booking table indexes
CREATE INDEX idx_booking_status ON booking(status);
CREATE INDEX idx_booking_property_status ON booking(property_id, status);
CREATE INDEX idx_booking_user_status ON booking(user_id, status);
CREATE INDEX idx_booking_status_dates ON booking(status, start_date, end_date);