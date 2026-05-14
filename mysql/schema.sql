-- =============================================
-- HOTEL MANAGEMENT SYSTEM - MySQL Schema
-- =============================================

DROP DATABASE IF EXISTS HotelManagementSystem;

CREATE DATABASE HotelManagementSystem;

USE HotelManagementSystem;

-- 1. Hotel Table
CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- 2. RoomType Table
-- -----------------------------------------------
CREATE TABLE RoomType (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    max_occupancy INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- 3. Room Table
-- -----------------------------------------------
CREATE TABLE Room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    type_id INT NOT NULL,
    hotel_id INT NOT NULL,
    status ENUM('Available', 'Occupied', 'Maintenance', 'Reserved') DEFAULT 'Available',
    floor_number INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES RoomType(type_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- -----------------------------------------------
-- 4. Guest Table
-- -----------------------------------------------
CREATE TABLE Guest (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    nationality VARCHAR(50),
    id_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- 5. Booking Table
-- -----------------------------------------------
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled') DEFAULT 'Confirmed',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id)
);

-- -----------------------------------------------
-- 6. BookingRoom Junction Table
-- -----------------------------------------------
CREATE TABLE BookingRoom (
    booking_id INT NOT NULL,
    room_id INT NOT NULL,
    PRIMARY KEY (booking_id, room_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE RESTRICT
);

-- -----------------------------------------------
-- 7. Payment Table
-- -----------------------------------------------
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Cash', 'Card', 'MobileMoney', 'BankTransfer') NOT NULL,
    transaction_id VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- -----------------------------------------------
-- 8. Staff Table
-- -----------------------------------------------
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- -----------------------------------------------
-- 9. Review Table
-- -----------------------------------------------
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    booking_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- -----------------------------------------------
-- 10. Service Table
-- -----------------------------------------------
CREATE TABLE Service (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    service_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- =============================================
-- Sample Data
-- =============================================

-- Hotel
INSERT INTO Hotel (name, location) VALUES
('Addis Grand Hotel', 'Bole, Addis Ababa');

-- RoomType
INSERT INTO RoomType (type_name, price_per_night, max_occupancy, description) VALUES
('Single', 850.00, 1, 'Standard single room with one bed'),
('Double', 1200.00, 2, 'Room with one double bed'),
('Deluxe', 1800.00, 2, 'Spacious room with better amenities'),
('Suite', 3500.00, 4, 'Luxury suite with living area');

-- Room 
INSERT INTO Room (room_number, type_id, hotel_id, status, floor_number) VALUES
('A-101', 1, 1, 'Available', 1),
('A-102', 2, 1, 'Available', 1),
('B-205', 3, 1, 'Available', 2),
('C-310', 4, 1, 'Available', 3);

-- Guest
INSERT INTO Guest (full_name, phone, email, nationality, id_number) VALUES
('Biruk Alemu',  '+251911000001', 'biruk@email.com',  'Ethiopian', 'ET-001'),
('Meron Tesfaye','+251911000002', 'meron@email.com',  'Ethiopian', 'ET-002'),
('Dawit Kebede', '+251911000003', 'dawit@email.com',  'Ethiopian', 'ET-003');

-- Staff 
INSERT INTO Staff (hotel_id, full_name, position, phone, email, hire_date) VALUES
(1, 'Selam Haile',   'Receptionist', '+251922000001', 'selam@hotel.com',  '2023-01-15'),
(1, 'Yonas Girma',   'Manager',      '+251922000002', 'yonas@hotel.com',  '2022-06-01');

-- Booking
INSERT INTO Booking (guest_id, check_in_date, check_out_date, total_amount, status) VALUES
(1, '2026-04-18', '2026-04-20', 1700.00, 'CheckedOut'),
(2, '2026-04-21', '2026-04-23', 3600.00, 'CheckedOut'),
(3, '2026-04-24', '2026-04-26', 7000.00, 'CheckedOut');

-- BookingRoom
INSERT INTO BookingRoom (booking_id, room_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Payment
INSERT INTO Payment (booking_id, amount, payment_method, transaction_id) VALUES
(1, 1700.00, 'Cash',         NULL),
(2, 3600.00, 'Card',         'TXN-20260422'),
(3, 7000.00, 'MobileMoney',  'TXN-20260425');

-- Review
INSERT INTO Review (guest_id, booking_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Excellent stay! Very clean room and friendly staff.', '2026-04-20'),
(2, 2, 4, 'Good hotel but WiFi was slow during peak hours.',     '2026-04-22'),
(3, 3, 5, 'Perfect experience! Will definitely come back.',      '2026-04-25');

-- Service
INSERT INTO Service (booking_id, type, cost) VALUES
(1, 'Room Service - Grilled Chicken & Fries', 680.00),
(2, 'Laundry',                                 150.00),
(3, 'Airport Pickup',                          500.00);
