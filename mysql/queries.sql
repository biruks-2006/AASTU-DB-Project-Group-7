-- =============================================
-- HOTEL MANAGEMENT SYSTEM - MySQL Queries
-- =============================================

USE HotelManagementSystem;

-- -----------------------------------------------
-- Query 1: Available Rooms List
-- -----------------------------------------------
SELECT r.room_number, rt.type_name, rt.price_per_night, r.status
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Available'
ORDER BY rt.price_per_night;


-- -----------------------------------------------
-- Query 2: Recent Bookings List
-- -----------------------------------------------
SELECT 
    b.booking_id,
    g.full_name AS guest_name,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.status
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
ORDER BY b.booking_date DESC;

-- -----------------------------------------------
-- Query 3: All Rooms with Details
-- -----------------------------------------------
SELECT 
    h.name AS hotel_name,
    r.room_number,
    rt.type_name,
    rt.price_per_night,
    rt.max_occupancy,
    r.status,
    r.floor_number
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
JOIN Hotel h ON r.hotel_id = h.hotel_id;

-- -----------------------------------------------
-- Query 4: Currently Occupied Rooms with Guest Info
-- -----------------------------------------------
SELECT 
    r.room_number,
    rt.type_name,
    g.full_name AS guest_name,
    b.check_in_date,
    b.check_out_date
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
JOIN BookingRoom br ON r.room_id = br.room_id
JOIN Booking b ON br.booking_id = b.booking_id
JOIN Guest g ON b.guest_id = g.guest_id
WHERE r.status = 'Occupied' AND b.status = 'CheckedIn';

-- -----------------------------------------------
-- Query 5: Monthly Revenue Report
-- -----------------------------------------------
SELECT 
    DATE_FORMAT(b.booking_date, '%Y-%m') AS month,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM Booking b
WHERE b.status != 'Cancelled'
GROUP BY DATE_FORMAT(b.booking_date, '%Y-%m')
ORDER BY month DESC;

-- -----------------------------------------------
-- Query 6: Guest Spending Summary
-- -----------------------------------------------
SELECT 
    g.full_name,
    g.phone,
    g.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_spent
FROM Guest g
LEFT JOIN Booking b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.full_name, g.phone, g.email
ORDER BY total_spent DESC;

-- -----------------------------------------------
-- Query 7: Available Rooms for a Date Range
-- -----------------------------------------------
-- Parameters: check_in = '2026-05-05', check_out = '2026-05-10'
-- Change these two date values to search different date ranges.
SELECT r.room_number, rt.type_name, rt.price_per_night
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Available'
AND r.room_id NOT IN (
    SELECT br.room_id 
    FROM BookingRoom br
    JOIN Booking b ON br.booking_id = b.booking_id
    WHERE b.check_in_date <= '2026-05-10' 
      AND b.check_out_date >= '2026-05-05'
      AND b.status != 'Cancelled'
);

-- -----------------------------------------------
-- Query 8a: Search Booking by Guest Name
-- -----------------------------------------------
SELECT 
    b.booking_id,
    g.full_name,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.status,
    b.booking_date
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
WHERE g.full_name LIKE '%Biruk%';

-- -----------------------------------------------
-- Query 8b: Check-In a Guest
-- -----------------------------------------------
UPDATE Booking 
SET status = 'CheckedIn' 
WHERE booking_id = 1;

UPDATE Room 
SET status = 'Occupied' 
WHERE room_id IN (
    SELECT room_id FROM BookingRoom WHERE booking_id = 1
);

-- -----------------------------------------------
-- Query 9: Cancel a Booking
-- -----------------------------------------------
UPDATE Booking 
SET status = 'Cancelled' 
WHERE booking_id = 5;

-- -----------------------------------------------
-- Query 10: Payment Method Breakdown
-- -----------------------------------------------
SELECT 
    payment_method, 
    COUNT(*) AS number_of_transactions,
    SUM(amount) AS total_collected,
    ROUND(AVG(amount), 2) AS average_payment_amount
FROM Payment
GROUP BY payment_method
ORDER BY total_collected DESC;

-- -----------------------------------------------
-- Query 11: Today's Check-ins and Check-outs
-- -----------------------------------------------
SELECT 'CHECK-IN' AS activity_type,
       g.full_name AS guest_name,
       r.room_number,
       b.check_in_date AS date
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
JOIN BookingRoom br ON b.booking_id = br.booking_id
JOIN Room r ON br.room_id = r.room_id
WHERE b.check_in_date = CURDATE() AND b.status = 'Confirmed'

UNION ALL

SELECT 'CHECK-OUT' AS activity_type,
       g.full_name AS guest_name,
       r.room_number,
       b.check_out_date AS date
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
JOIN BookingRoom br ON b.booking_id = br.booking_id
JOIN Room r ON br.room_id = r.room_id
WHERE b.check_out_date = CURDATE() AND b.status = 'CheckedIn'

ORDER BY activity_type;

-- -----------------------------------------------
-- Query 12: Rooms Currently Under Maintenance
-- -----------------------------------------------
SELECT 
    r.room_number,
    rt.type_name,
    r.floor_number,
    rt.price_per_night
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Maintenance'
ORDER BY r.floor_number, r.room_number;

-- -----------------------------------------------
-- Query 13: Most Popular Room Types by Bookings
-- -----------------------------------------------
SELECT 
    rt.type_name,
    COUNT(br.room_id) AS times_booked
FROM RoomType rt
JOIN Room r ON rt.type_id = r.type_id
JOIN BookingRoom br ON r.room_id = br.room_id
GROUP BY rt.type_name
ORDER BY times_booked DESC;

-- -----------------------------------------------
-- Query 14: Average Guest Stay Duration
-- -----------------------------------------------
SELECT 
    ROUND(AVG(DATEDIFF(check_out_date, check_in_date)), 2) AS average_stay_days
FROM Booking
WHERE status != 'Cancelled';

-- -----------------------------------------------
-- Query 15: All Guest Reviews with Guest Info
-- -----------------------------------------------
SELECT 
    g.full_name AS guest_name,
    b.booking_id,
    r.room_number,
    rv.rating,
    rv.comment,
    rv.review_date
FROM Review rv
JOIN Guest g ON rv.guest_id = g.guest_id
JOIN Booking b ON rv.booking_id = b.booking_id
JOIN BookingRoom br ON b.booking_id = br.booking_id
JOIN Room r ON br.room_id = r.room_id
ORDER BY rv.review_date DESC;

-- -----------------------------------------------
-- Query 16: Average Rating per Room Type
-- -----------------------------------------------
SELECT 
    rt.type_name,
    ROUND(AVG(rv.rating), 2) AS average_rating,
    COUNT(rv.review_id) AS total_reviews
FROM Review rv
JOIN Booking b ON rv.booking_id = b.booking_id
JOIN BookingRoom br ON b.booking_id = br.booking_id
JOIN Room r ON br.room_id = r.room_id
JOIN RoomType rt ON r.type_id = rt.type_id
GROUP BY rt.type_name
ORDER BY average_rating DESC;

-- -----------------------------------------------
-- Query 17: All Room Service Orders per Booking
-- -----------------------------------------------
SELECT 
    b.booking_id,
    g.full_name AS guest_name,
    s.type AS service_type,
    s.cost,
    s.service_date
FROM Service s
JOIN Booking b ON s.booking_id = b.booking_id
JOIN Guest g ON b.guest_id = g.guest_id
ORDER BY s.service_date DESC;

-- -----------------------------------------------
-- Query 18: Total Revenue Including Services
-- -----------------------------------------------
SELECT 
    g.full_name AS guest_name,
    b.booking_id,
    b.total_amount AS room_charge,
    COALESCE(SUM(s.cost), 0) AS service_charge,
    b.total_amount + COALESCE(SUM(s.cost), 0) AS grand_total
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
LEFT JOIN Service s ON b.booking_id = s.booking_id
WHERE b.status != 'Cancelled'
GROUP BY g.full_name, b.booking_id, b.total_amount
ORDER BY grand_total DESC;

-- -----------------------------------------------
-- Query 19: Staff List by Hotel
-- -----------------------------------------------
SELECT 
    h.name AS hotel_name,
    s.full_name AS staff_name,
    s.position,
    s.phone,
    s.hire_date
FROM Staff s
JOIN Hotel h ON s.hotel_id = h.hotel_id
ORDER BY h.name, s.position;