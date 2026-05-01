CREATE DATABASE HOTELS;
USE HOTELS;
CREATE TABLE HOTEL(
 HOTEL_ID INT NOT NULL AUTO_INCREMENT,
 NAME VARCHAR(255) NOT NULL,
 LOCATION VARCHAR(255) NOT NULL,
 PRIMARY KEY(HOTEL_ID)
);
INSERT INTO HOTEL(HOTEL_ID, NAME, LOCATION)
VALUES(1,'HILINA BEKA','KILINTO');
SELECT * FROM HOTEL;
create table room(
room_id int primary key auto_increment,
price int,
room_number int,
status varchar(50),
HOTEL_ID int,
type_id int
);

create table staff(
staff_id int primary key auto_increment,
first_name varchar(255),
last_name varchar(255),
role varchar(255),
HOTEL_ID int
);

create table review(
review_id int primary key auto_increment,
rating int,
comment varchar(50),
guest_id int
);

create table guest(
guest_id int primary key auto_increment,
first_name varchar(255),
last_name varchar(255),
phone_number int,
address varchar(50),
email varchar(50),
nationality varchar(50),
booking_id int
);
alter table guest 
drop foreign key booking_id ;
create table booking(
booking_id int primary key auto_increment,
check_in_date int,
check_out_date int,
total_amount int,
status varchar(50),
guest_id int
);

create table room_type(
type_id int primary key auto_increment,
name varchar(50),
description varchar(50)
);

create table service(
service_id int primary key auto_increment,
cost int,
booking_id int,
description varchar(50),
foreign key(booking_id) references booking(booking_id)
);

create table payment(
payment_id int primary key auto_increment,
date int,
amount int,
method varchar(50),
booking_id int ,
foreign key(booking_id) references booking(booking_id)
);

create table includes(
booking_id int ,
room_id int,
primary key(booking_id, room_id),
foreign key(room_id) references room(room_id),
foreign key(booking_id) references booking(booking_id)
);