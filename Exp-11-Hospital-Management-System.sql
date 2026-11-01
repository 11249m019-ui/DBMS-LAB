-- DBMS MINI-PROJECT 2: HOSPITAL MANAGEMENT SYSTEM

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS Project2_HospitalDB;
USE Project2_HospitalDB;

-- 2. CREATE DOCTOR TABLE
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(40) NOT NULL
);

-- 3. INSERT DOCTOR RECORDS
INSERT INTO Doctor VALUES
(1, 'Dr Meera', 'Cardiology'),
(2, 'Dr Raj', 'Orthopedics'),
(3, 'Dr Anil', 'General Medicine');

-- 4. CREATE PATIENT TABLE
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    city VARCHAR(30)
);

-- 5. INSERT PATIENT RECORDS
INSERT INTO Patient VALUES
(201, 'Kavya', 32, 'Chennai'),
(202, 'Rohan', 45, 'Hyderabad'),
(203, 'Anita', 29, 'Chennai');

-- 6. CREATE APPOINTMENT TABLE
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- 7. INSERT APPOINTMENT RECORDS
INSERT INTO Appointment VALUES
(301, 201, 1, '2026-10-15', 'Booked'),
(302, 202, 2, '2026-10-16', 'Completed'),
(303, 203, 3, '2026-10-16', 'Booked'),
(304, 201, 3, '2026-10-17', 'Completed');

-- 8. CREATE BILL TABLE
CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- 9. INSERT BILL RECORDS
INSERT INTO Bill VALUES
(401, 302, 1500, 'Paid'),
(402, 304, 800, 'Pending');

-- 10. QUERY 1: APPOINTMENT SCHEDULE
SELECT
    a.appointment_id,
    p.patient_name,
    d.doctor_name,
    a.visit_date,
    a.status
FROM Appointment a
JOIN Patient p ON p.patient_id = a.patient_id
JOIN Doctor d ON d.doctor_id = a.doctor_id
ORDER BY a.appointment_id;

-- 11. QUERY 2: APPOINTMENTS BY DOCTOR
SELECT
    d.doctor_name,
    COUNT(a.appointment_id) AS total_visits
FROM Doctor d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY d.doctor_id;

-- 12. QUERY 3: UNPAID BILLS
SELECT
    p.patient_name,
    b.amount
FROM Bill b
JOIN Appointment a ON a.appointment_id = b.appointment_id
JOIN Patient p ON p.patient_id = a.patient_id
WHERE b.payment_status = 'Pending';

-- 13. QUERY 4: TOTAL BILLED
SELECT SUM(amount) AS total_billed
FROM Bill;

-- 14. PRACTICE QUERY 1: LIST BOOKED APPOINTMENTS
SELECT *
FROM Appointment
WHERE status = 'Booked';

-- 15. PRACTICE QUERY 2: PATIENTS VISITING MORE THAN ONCE
SELECT
    p.patient_name,
    COUNT(a.appointment_id) AS total_visits
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING COUNT(a.appointment_id) > 1;

-- 16. PRACTICE QUERY 3: TOTAL BILL PER PATIENT
SELECT
    p.patient_name,
    SUM(b.amount) AS total_bill
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
JOIN Bill b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_id, p.patient_name;

-- 17. PRACTICE QUERY 4: APPOINTMENTS WITHOUT BILLS
SELECT
    a.appointment_id,
    p.patient_name,
    a.visit_date
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
LEFT JOIN Bill b ON a.appointment_id = b.appointment_id
WHERE b.bill_id IS NULL;

-- 18. PRACTICE QUERY 5: DOCTORS BY SPECIALIZATION
SELECT
    doctor_name,
    specialization
FROM Doctor
ORDER BY specialization;

-- 19. ADD A VALID DOCTOR RECORD
INSERT INTO Doctor VALUES
(4, 'Dr Priya', 'Neurology');

-- 20. MODIFY AN EXISTING PATIENT RECORD
UPDATE Patient
SET city = 'Bangalore'
WHERE patient_id = 203;

-- 21. VALIDATE TABLES
SHOW TABLES;

-- 22. CHECK RECORD COUNTS
SELECT COUNT(*) AS doctor_count FROM Doctor;
SELECT COUNT(*) AS patient_count FROM Patient;
SELECT COUNT(*) AS appointment_count FROM Appointment;
SELECT COUNT(*) AS bill_count FROM Bill;

-- 23. DISPLAY TABLE RECORDS
SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM Appointment;
SELECT * FROM Bill;

-- 24. CHECK TABLE STRUCTURES
SHOW CREATE TABLE Doctor;
SHOW CREATE TABLE Patient;
SHOW CREATE TABLE Appointment;
SHOW CREATE TABLE Bill;
