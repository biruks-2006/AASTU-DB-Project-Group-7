--1. Available Rooms List
SELECT r.room_number, rt.type_name, rt.price_per_night, r.status
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Available'
ORDER BY rt.price_per_night;

--2. Recent Bookings List
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

--3. All Rooms with Details
SELECT 
    r.room_number,
    rt.type_name,
    rt.price_per_night,
    rt.max_occupancy,
    r.status,
    r.floor_number
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id;

--4. Currently Occupied Rooms with Guest Info
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

--5. Monthly Revenue Report
SELECT 
    DATE_FORMAT(b.booking_date, '%Y-%m') AS month,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM Booking b
WHERE b.status != 'Cancelled'
GROUP BY DATE_FORMAT(b.booking_date, '%Y-%m')
ORDER BY month DESC;

--6. Guest Spending Summary
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

--7. Available Rooms for Date Range
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

--8. Search Booking by Guest Name
SELECT b.*, g.full_name
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
WHERE g.full_name LIKE '%Biruk%';

UPDATE Booking SET status = 'CheckedIn' WHERE booking_id = 1;
UPDATE Room SET status = 'Occupied' 
WHERE room_id IN (SELECT room_id FROM BookingRoom WHERE booking_id = 1);

-- 9. Cancel a booking
UPDATE Booking SET status = 'Cancelled' WHERE booking_id = 5;

SELECT 
    rt.type_name,
    COUNT(br.room_id) AS times_booked
FROM RoomType rt
JOIN Room r ON rt.type_id = r.type_id
JOIN BookingRoom br ON r.room_id = br.room_id
GROUP BY rt.type_name
ORDER BY times_booked DESC;

SELECT 
    AVG(DATEDIFF(check_out_date, check_in_date)) AS average_stay_days
FROM Booking
WHERE status != 'Cancelled';

-- 10. Payment Method Breakdown
SELECT payment_method, 
       COUNT(*) AS number_of_transactions,
       SUM(amount) AS total_collected,
       ROUND(AVG(amount), 2) AS average_payment_amount
FROM Payment
GROUP BY payment_method
ORDER BY total_collected DESC;

-- 11. Today's Check-ins and Check-outs
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

--12. Rooms Currently Under Maintenance
SELECT r.room_number,
       rt.type_name,
       r.floor_number,
       rt.price_per_night
FROM Room r
JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.status = 'Maintenance'
ORDER BY r.floor_number, r.room_number;