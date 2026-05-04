-- =============================================
-- HOTEL MANAGEMENT SYSTEM - MySQL Queries
-- =============================================

USE hotel_management;

-- ====================== 1. BASIC SELECT QUERIES ======================

-- 1. Show all available rooms
SELECT r.room_number, rt.type_name, rt.price_per_night, r.status
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Available'
ORDER BY rt.price_per_night;

-- 2. Show all bookings with guest information
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

-- 3. Show room details with type information
SELECT 
    r.room_number,
    rt.type_name,
    rt.price_per_night,
    rt.max_occupancy,
    r.status,
    r.floor_number
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id;

-- ====================== 2. IMPORTANT REPORT QUERIES ======================

-- 4. Current Occupancy Report (Rooms that are Occupied)
SELECT 
    r.room_number,
    rt.type_name,
    g.full_name AS guest_name,
    b.check_in_date,
    b.check_out_date
FROM Room r
JOIN BookingRoom br ON r.room_id = br.room_id
JOIN Booking b ON br.booking_id = b.booking_id
JOIN Guest g ON b.guest_id = g.guest_id
WHERE r.status = 'Occupied' AND b.status = 'CheckedIn';

-- 5. Revenue Report (Total revenue by month)
SELECT 
    DATE_FORMAT(b.booking_date, '%Y-%m') AS month,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM Booking b
WHERE b.status != 'Cancelled'
GROUP BY DATE_FORMAT(b.booking_date, '%Y-%m')
ORDER BY month DESC;

-- 6. Guest Booking History
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

-- ====================== 3. SEARCH & FILTER QUERIES ======================

-- 7. Find available rooms between specific dates
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
);

-- 8. Find bookings by guest name
SELECT b.*, g.full_name
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
WHERE g.full_name LIKE '%Biruk%';

-- ====================== 4. UPDATE & DELETE EXAMPLES ======================

-- 9. Check-in a guest (Update booking and room status)
UPDATE Booking SET status = 'CheckedIn' WHERE booking_id = 1;
UPDATE Room SET status = 'Occupied' 
WHERE room_id IN (SELECT room_id FROM BookingRoom WHERE booking_id = 1);

-- 10. Cancel a booking
UPDATE Booking SET status = 'Cancelled' WHERE booking_id = 5;

-- ====================== 5. ADVANCED / AGGREGATION ======================

-- 11. Most popular room type
SELECT 
    rt.type_name,
    COUNT(br.room_id) AS times_booked
FROM RoomType rt
JOIN Room r ON rt.type_id = r.type_id
JOIN BookingRoom br ON r.room_id = br.room_id
GROUP BY rt.type_name
ORDER BY times_booked DESC;

-- 12. Average stay duration
SELECT 
    AVG(DATEDIFF(check_out_date, check_in_date)) AS average_stay_days
FROM Booking
WHERE status != 'Cancelled'; 
                                                                                                                                