-- DBMS MINI-PROJECT 3: RAILWAY RESERVATION SYSTEM

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS Project3_RailwayDB;
USE Project3_RailwayDB;

-- 2. CREATE TRAIN TABLE
CREATE TABLE Train (
    train_id INT PRIMARY KEY,
    train_name VARCHAR(50) NOT NULL,
    origin VARCHAR(40) NOT NULL,
    destination VARCHAR(40) NOT NULL,
    capacity INT NOT NULL
);

-- 3. INSERT TRAIN RECORDS
INSERT INTO Train VALUES
(101, 'Coastal Express', 'Chennai', 'Vijayawada', 3),
(102, 'Deccan Express', 'Hyderabad', 'Bengaluru', 2);

-- 4. CREATE PASSENGER TABLE
CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(50) NOT NULL,
    age INT NOT NULL
);

-- 5. INSERT PASSENGER RECORDS
INSERT INTO Passenger VALUES
(1, 'Arun', 24),
(2, 'Divya', 31),
(3, 'Rahul', 40),
(4, 'Sneha', 28);

-- 6. CREATE JOURNEY TABLE
CREATE TABLE Journey (
    journey_id INT PRIMARY KEY,
    train_id INT NOT NULL,
    journey_date DATE NOT NULL,
    FOREIGN KEY (train_id) REFERENCES Train(train_id),
    UNIQUE (train_id, journey_date)
);

-- 7. INSERT JOURNEY RECORDS
INSERT INTO Journey VALUES
(501, 101, '2026-11-01'),
(502, 102, '2026-11-02');

-- 8. CREATE BOOKING TABLE
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    journey_id INT NOT NULL,
    passenger_id INT NOT NULL,
    seat_no INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    fare DECIMAL(9,2) NOT NULL,
    FOREIGN KEY (journey_id) REFERENCES Journey(journey_id),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
);

-- 9. INSERT BOOKING RECORDS
INSERT INTO Booking VALUES
(701, 501, 1, 1, 'Confirmed', 450),
(702, 501, 2, 2, 'Confirmed', 450),
(703, 502, 3, 1, 'Confirmed', 600),
(704, 501, 4, 3, 'Cancelled', 450);

-- 10. QUERY 1: CONFIRMED TICKETS
SELECT
    b.booking_id,
    p.passenger_name,
    t.train_name,
    b.seat_no
FROM Booking b
JOIN Passenger p ON p.passenger_id = b.passenger_id
JOIN Journey j ON j.journey_id = b.journey_id
JOIN Train t ON t.train_id = j.train_id
WHERE b.status = 'Confirmed'
ORDER BY b.booking_id;

-- 11. QUERY 2: AVAILABLE SEATS PER JOURNEY
SELECT
    j.journey_id,
    t.train_name,
    t.capacity - COUNT(
        CASE WHEN b.status = 'Confirmed' THEN 1 END
    ) AS available_seats
FROM Journey j
JOIN Train t ON t.train_id = j.train_id
LEFT JOIN Booking b ON b.journey_id = j.journey_id
GROUP BY j.journey_id, t.train_name, t.capacity
ORDER BY j.journey_id;

-- 12. QUERY 3: CANCELLED BOOKINGS
SELECT booking_id, seat_no
FROM Booking
WHERE status = 'Cancelled';

-- 13. QUERY 4: CONFIRMED FARE TOTALS
SELECT
    j.journey_id,
    SUM(b.fare) AS total_fare
FROM Journey j
JOIN Booking b ON b.journey_id = j.journey_id
WHERE b.status = 'Confirmed'
GROUP BY j.journey_id
ORDER BY j.journey_id;

-- 14. PRACTICE QUERY 1: SEARCH TRAINS BY ORIGIN
SELECT *
FROM Train
WHERE origin = 'Chennai';

-- 15. PRACTICE QUERY 2: COUNT PASSENGERS BY JOURNEY
SELECT
    j.journey_id,
    COUNT(b.passenger_id) AS total_passengers
FROM Journey j
LEFT JOIN Booking b ON j.journey_id = b.journey_id
GROUP BY j.journey_id;

-- 16. PRACTICE QUERY 3: LIST UNBOOKED SEATS
SELECT
    j.journey_id,
    t.train_name,
    s.seat_no
FROM Journey j
JOIN Train t ON j.train_id = t.train_id
JOIN (
    SELECT 1 AS seat_no
    UNION SELECT 2
    UNION SELECT 3
    UNION SELECT 4
    UNION SELECT 5
) s ON s.seat_no <= t.capacity
WHERE NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.journey_id = j.journey_id
      AND b.seat_no = s.seat_no
      AND b.status = 'Confirmed'
);

-- 17. PRACTICE QUERY 4: PASSENGERS WITHOUT CONFIRMED BOOKINGS
SELECT
    p.passenger_id,
    p.passenger_name
FROM Passenger p
WHERE NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.passenger_id = p.passenger_id
      AND b.status = 'Confirmed'
);

-- 18. PRACTICE QUERY 5: FARE TOTALS BY TRAIN
SELECT
    t.train_name,
    SUM(b.fare) AS total_fare
FROM Train t
JOIN Journey j ON t.train_id = j.train_id
JOIN Booking b ON j.journey_id = b.journey_id
WHERE b.status = 'Confirmed'
GROUP BY t.train_id, t.train_name;

-- 19. ADD A VALID PASSENGER RECORD
INSERT INTO Passenger VALUES
(5, 'Kiran', 35);

-- 20. MODIFY AN EXISTING PASSENGER RECORD
UPDATE Passenger
SET age = 25
WHERE passenger_id = 1;

-- 21. VALIDATE TABLES
SHOW TABLES;

-- 22. CHECK RECORD COUNTS
SELECT COUNT(*) AS train_count FROM Train;
SELECT COUNT(*) AS passenger_count FROM Passenger;
SELECT COUNT(*) AS journey_count FROM Journey;
SELECT COUNT(*) AS booking_count FROM Booking;

-- 23. DISPLAY ALL RECORDS
SELECT * FROM Train;
SELECT * FROM Passenger;
SELECT * FROM Journey;
SELECT * FROM Booking;

-- 24. CHECK TABLE STRUCTURES
SHOW CREATE TABLE Train;
SHOW CREATE TABLE Passenger;
SHOW CREATE TABLE Journey;
SHOW CREATE TABLE Booking;
