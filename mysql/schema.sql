CREATE TABLE RoomType (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,           -- Single, Double, Deluxe, Suite, etc.
    price_per_night DECIMAL(10,2) NOT NULL,
    max_occupancy INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,   -- e.g., A-101, B-205
    type_id INT NOT NULL,
    status ENUM('Available', 'Occupied', 'Maintenance', 'Reserved') DEFAULT 'Available',
    floor_number INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES RoomType(type_id)
);
CREATE TABLE Guest (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    nationality VARCHAR(50),
    id_number VARCHAR(50),                     -- Passport or National ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
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
CREATE TABLE BookingRoom (
    booking_id INT NOT NULL,
    room_id INT NOT NULL,
    PRIMARY KEY (booking_id, room_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE RESTRICT
);
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Cash', 'Card', 'MobileMoney', 'BankTransfer') NOT NULL,
    transaction_id VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Sample Data
-- =============================================
INSERT INTO RoomType (type_name, price_per_night, max_occupancy, description) VALUES
('Single', 850.00, 1, 'Standard single room with one bed'),
('Double', 1200.00, 2, 'Room with one double bed'),
('Deluxe', 1800.00, 2, 'Spacious room with better amenities'),
('Suite', 3500.00, 4, 'Luxury suite with living area');

INSERT INTO Room (room_number, type_id, status, floor_number) VALUES
('A-101', 1, 'Available', 1),
('A-102', 2, 'Available', 1),
('B-205', 3, 'Available', 2),
('C-310', 4, 'Available', 3);