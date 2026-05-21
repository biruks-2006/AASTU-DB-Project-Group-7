# **Hotel Management System Database Design**

---

## \*\* \*\*

**Course:** Database Systems  
**Assignment:** Database Design Project  
**Title:** Hotel Management System  
**Student Name:**
| No | Name | ID |
|----|-------------------|-------------|
| 1 | Beka Solomon | ETS 0242/17 |
| 2 | Deborah Mesfin | ETS 0434/17 |
| 3 | Biruk Molla | ETS 0336/17 |
| 4 | Abreham Teshale | ETS 0076/17 |
| 5 | Awach Garang | ETS 1869/17 |
| 6 | Gakeer Deng | ETS 1865/17 |
**Instructor:** Mr. Yaynshet Medhin
**Date:** 2026

---

# **1. Problem Statement**

Hotels manage essential operations such as reservations, customer records, room allocation, and billing. When these processes are handled manually or through disconnected systems, several challenges arise:

- Double bookings due to poor coordination
- Data inconsistency across multiple records
- Inefficient management of guest and room information
- Lack of real-time room availability tracking
- Errors in billing and payment processing

These issues reduce operational efficiency and negatively impact both staff performance and customer experience.

---

# **2. Project Objective**

The objective of this project is to design a **centralized and well-structured database system** for hotel management.

The system aims to:

- Manage room bookings efficiently and accurately
- Store and maintain guest information in an organized manner
- Support smooth check-in and check-out processes
- Automate billing and payment tracking
- Provide real-time updates on room availability
- Improve data accuracy, consistency, and accessibility

---

# **3. System Overview**

The system is designed using a relational database model. The main entities include:

- **Guest**
- **Hotel**
- **Room**
- **RoomType**
- **Booking**
- **Booking_Room**
- **Payment**
- **Staff**
- **Review**
- **Service**

These entities represent real-world components of a hotel system and are connected through relationships such as bookings, services, and payments.

---

# **4. ER Diagram**

The **Entity-Relationship (ER) Diagram** provides a high-level representation of the system.

It illustrates:

- Entities and their attributes
- Relationships between entities
- Cardinalities (1:N, M:N)
- Primary and foreign keys

<img width="1280" height="970" alt="image" src="https://github.com/user-attachments/assets/0eb59633-4da5-4775-898b-44ca71ce5f8a" />

---

# **5. Logical Schema**

The logical schema converts the ER diagram into relational tables.

Each table includes:

- Primary Keys (PK)
- Foreign Keys (FK)
- Attributes with appropriate data types

This ensures:

- Clear structure
- Efficient querying
- Strong referential integrity

<img width="2047" height="848" alt="image" src="https://github.com/user-attachments/assets/38fc381a-195f-465d-bdef-27a2e91a363e" />

---

# **6. Normalization (Up to BCNF)**

## **6.1 Why Normalization is Important**

Without normalization:

- Data redundancy increases
- Updates become inconsistent
- Insert and delete operations may cause anomalies

Normalization ensures a clean and efficient database design.

---

## **6.2 Functional Dependencies**

The system follows these key functional dependencies:

- guest_id → name, phone, email, address, nationality
- hotel_id → name, location
- type_id → name, description
- room_id → type_id, hotel_id, room_number, price_per_night, status
- staff_id → hotel_id, name, role
- booking_id → guest_id, check_in_date, check_out_date, total_amount, status
- payment_id → booking_id, amount, date, method
- review_id → guest_id, rating, comment
- service_id → booking_id, type, cost

---

## **6.3 Normal Forms**

### **First Normal Form (1NF)**

- All attributes contain atomic values
- No repeating groups

✔ All tables satisfy 1NF

---

### **Second Normal Form (2NF)**

- No partial dependency on composite keys

✔ All tables satisfy 2NF

---

### **Third Normal Form (3NF)**

- No transitive dependency
- Non-key attributes depend only on the primary key

✔ All tables satisfy 3NF

---

### **Boyce-Codd Normal Form (BCNF)**

A table is in BCNF if:

> Every determinant is a candidate key

✔ In this system:

- Each table has a well-defined primary key
- All dependencies are based on that key
- No non-key attribute determines another non-key attribute

---

## **6.4 Final Result**

The database is fully normalized up to **BCNF**, ensuring:

- Minimal redundancy
- High data consistency
- Efficient data management
- Scalability

---

# **7. Input, Output, and Reports Design**

## **7.1 Inputs (Forms)**

The system includes input forms for:

- Guest registration
- Booking creation
- Payment entry
- Service requests

These forms ensure structured and accurate data entry.

---

## **7.2 Outputs**

The system generates outputs such as:

- Booking confirmations
- Payment receipts
- Room availability status
- Payment method breakdown reports
- Today's check-ins and check-outs
- Rooms currently under maintenance

---

## **7.3 Reports**

The system supports reports including:

- Booking history
- Revenue and payment summaries
- Room occupancy reports
- Guest activity reports

These reports assist in decision-making and operational analysis.

---

# Technologies Used

MySQL
MySQL is used as the primary relational database to store and manage all structured data.

Purpose: Stores all core entities — guests, rooms, bookings, payments, staff, and more
Why MySQL: Enforces relational integrity via foreign keys, supports complex JOINs, and is ACID-compliant for reliable booking and payment operations

MongoDB
MongoDB is used as a supplementary NoSQL database for flexible or semi-structured data.

Purpose: Stores guest activity logs, service request details, and audit records
Why MongoDB: Schema-less design handles variable data structures that don't map cleanly to relational tables

# How to Run the Project

Prerequisites

MySQL
MongoDB

Step 1 — Set Up MySQL
bash# Start MySQL
sudo service mysql start # Linux/macOS
net start MySQL80 # Windows

# Log in

mysql -u root -p

# Create and use the database

CREATE DATABASE hotel_management;
USE hotel_management;

# Run the schema script

mysql -u root -p hotel_management < sql/schema.sql
Step 2 — Set Up MongoDB
bash# Start MongoDB
sudo service mongod start # Linux/macOS
net start MongoDB # Windows

# Open shell and create collections

mongosh
use hotel_management_logs
db.createCollection("guestLogs")
db.createCollection("serviceRequests")
db.createCollection("auditTrail")
Step 3 — Run Sample Queries
sql-- Check available rooms
SELECT room_number, price_per_night, status
FROM Room WHERE status = 'available';

-- View bookings with guest names
SELECT b.booking_id, g.name, b.check_in_date, b.check_out_date
FROM Booking b JOIN Guest g ON b.guest_id = g.guest_id;

---

# **8. Conclusion**

This project presents a well-structured database design for a Hotel Management System. By applying normalization up to BCNF, the system achieves:

- Reduced redundancy
- Improved data integrity
- Efficient data handling
- Better scalability for real-world applications

The final design provides a strong foundation for implementing a complete hotel management solution.
