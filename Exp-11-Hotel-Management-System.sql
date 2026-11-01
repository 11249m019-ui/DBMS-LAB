-- DBMS MINI-PROJECT 5: HOTEL MANAGEMENT SYSTEM

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS Project5_HotelDB;
USE Project5_HotelDB;

-- 2. CREATE GUEST TABLE
CREATE TABLE Guest (
    guest_id INT PRIMARY KEY,
    guest_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 3. INSERT GUEST RECORDS
INSERT INTO Guest VALUES
(1, 'Arun', '9000000001'),
(2, 'Meera', '9000000002'),
(3, 'Ravi', '9000000003');

-- 4. CREATE ROOM TABLE
CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(20) NOT NULL,
    nightly_rate DECIMAL(10,2) NOT NULL
);

-- 5. INSERT ROOM RECORDS
INSERT INTO Room VALUES
(101, 'Standard', 2000),
(102, 'Deluxe', 3500),
(103, 'Suite', 6000);

-- 6. CREATE RESERVATION TABLE
CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    CHECK (check_out > check_in)
);

-- 7. INSERT RESERVATION RECORDS
INSERT INTO Reservation VALUES
(501, 1, 101, '2026-11-01', '2026-11-03', 'Confirmed'),
(502, 2, 102, '2026-11-02', '2026-11-05', 'Confirmed'),
(503, 3, 101, '2026-11-04', '2026-11-06', 'Cancelled');

-- 8. CREATE PAYMENT TABLE
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);

-- 9. INSERT PAYMENT RECORDS
INSERT INTO Payment VALUES
(601, 501, 4000, 'Paid'),
(602, 502, 10500, 'Pending');

-- 10. QUERY 1: CONFIRMED RESERVATIONS
SELECT
    g.guest_name,
    r.room_id,
    r.check_in,
    r.check_out
FROM Reservation r
JOIN Guest g ON g.guest_id = r.guest_id
WHERE r.status = 'Confirmed'
ORDER BY r.reservation_id;

-- 11. QUERY 2: ROOM AVAILABILITY
SELECT rm.room_id
FROM Room rm
WHERE rm.room_id = 101
AND NOT EXISTS (
    SELECT 1
    FROM Reservation r
    WHERE r.room_id = rm.room_id
      AND r.status = 'Confirmed'
      AND '2026-11-02' < r.check_out
      AND '2026-11-03' > r.check_in
);

-- 12. QUERY 3: UNPAID RESERVATIONS
SELECT
    g.guest_name,
    p.amount
FROM Payment p
JOIN Reservation r ON r.reservation_id = p.reservation_id
JOIN Guest g ON g.guest_id = r.guest_id
WHERE p.payment_status = 'Pending';

-- 13. QUERY 4: REVENUE COLLECTED
SELECT
    COALESCE(SUM(amount), 0) AS collected_revenue
FROM Payment
WHERE payment_status = 'Paid';

-- 14. PRACTICE QUERY 1: FIND AVAILABLE ROOMS
SELECT
    rm.room_id,
    rm.room_type,
    rm.nightly_rate
FROM Room rm
WHERE NOT EXISTS (
    SELECT 1
    FROM Reservation r
    WHERE r.room_id = rm.room_id
      AND r.status = 'Confirmed'
      AND '2026-11-02' < r.check_out
      AND '2026-11-03' > r.check_in
);

-- 15. PRACTICE QUERY 2: CALCULATE NIGHTS PER RESERVATION
SELECT
    reservation_id,
    guest_id,
    DATEDIFF(check_out, check_in) AS total_nights
FROM Reservation;

-- 16. PRACTICE QUERY 3: LIST CANCELLED RESERVATIONS
SELECT *
FROM Reservation
WHERE status = 'Cancelled';

-- 17. PRACTICE QUERY 4: FIND GUESTS WITH UNPAID BILLS
SELECT
    g.guest_name,
    p.amount,
    p.payment_status
FROM Guest g
JOIN Reservation r ON g.guest_id = r.guest_id
JOIN Payment p ON r.reservation_id = p.reservation_id
WHERE p.payment_status = 'Pending';

-- 18. PRACTICE QUERY 5: AVERAGE RATE BY ROOM TYPE
SELECT
    room_type,
    AVG(nightly_rate) AS average_rate
FROM Room
GROUP BY room_type;

-- 19. ADD A VALID GUEST RECORD
INSERT INTO Guest VALUES
(4, 'Kiran', '9000000004');

-- 20. MODIFY AN EXISTING ROOM RATE
UPDATE Room
SET nightly_rate = 2200
WHERE room_id = 101;

-- 21. VALIDATE TABLES
SHOW TABLES;

-- 22. CHECK RECORD COUNTS
SELECT COUNT(*) AS guest_count FROM Guest;
SELECT COUNT(*) AS room_count FROM Room;
SELECT COUNT(*) AS reservation_count FROM Reservation;
SELECT COUNT(*) AS payment_count FROM Payment;

-- 23. DISPLAY ALL RECORDS
SELECT * FROM Guest;
SELECT * FROM Room;
SELECT * FROM Reservation;
SELECT * FROM Payment;

-- 24. CHECK TABLE STRUCTURES
SHOW CREATE TABLE Guest;
SHOW CREATE TABLE Room;
SHOW CREATE TABLE Reservation;
SHOW CREATE TABLE Payment;
