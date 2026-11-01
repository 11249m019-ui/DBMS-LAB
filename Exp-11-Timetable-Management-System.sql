-- DBMS MINI-PROJECT 4: TIMETABLE MANAGEMENT SYSTEM

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS Project4_TimetableDB;
USE Project4_TimetableDB;

-- 2. CREATE FACULTY TABLE
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(50) NOT NULL
);

-- 3. INSERT FACULTY RECORDS
INSERT INTO Faculty VALUES
(1, 'Dr Kumar'),
(2, 'Dr Priya'),
(3, 'Dr Rao');

-- 4. CREATE SUBJECT TABLE
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL,
    faculty_id INT NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

-- 5. INSERT SUBJECT RECORDS
INSERT INTO Subject VALUES
(11, 'DBMS', 1),
(12, 'Networks', 2),
(13, 'AI', 3);

-- 6. CREATE ROOM TABLE
CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(20) NOT NULL UNIQUE,
    capacity INT NOT NULL
);

-- 7. INSERT ROOM RECORDS
INSERT INTO Room VALUES
(1, 'LAB-A', 60),
(2, 'ROOM-202', 50);

-- 8. CREATE SCHEDULE TABLE
CREATE TABLE Schedule (
    slot_id INT PRIMARY KEY,
    subject_id INT NOT NULL,
    room_id INT NOT NULL,
    day_name VARCHAR(12) NOT NULL,
    period_no INT NOT NULL,
    section_name VARCHAR(12) NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    UNIQUE (room_id, day_name, period_no),
    UNIQUE (section_name, day_name, period_no)
);

-- 9. INSERT SCHEDULE RECORDS
INSERT INTO Schedule VALUES
(101, 11, 1, 'Monday', 1, 'CSE-A'),
(102, 12, 2, 'Monday', 1, 'CSE-B'),
(103, 13, 1, 'Monday', 2, 'CSE-A'),
(104, 11, 2, 'Tuesday', 1, 'CSE-A');

-- 10. QUERY 1: WEEKLY TIMETABLE
SELECT
    sc.day_name,
    sc.period_no,
    sc.section_name,
    s.subject_name,
    f.faculty_name,
    r.room_name
FROM Schedule sc
JOIN Subject s ON sc.subject_id = s.subject_id
JOIN Faculty f ON s.faculty_id = f.faculty_id
JOIN Room r ON sc.room_id = r.room_id
ORDER BY
    FIELD(sc.day_name, 'Monday', 'Tuesday', 'Wednesday',
          'Thursday', 'Friday', 'Saturday'),
    sc.period_no,
    sc.section_name;

-- 11. QUERY 2: FACULTY TEACHING LOAD
SELECT
    f.faculty_name,
    COUNT(sc.slot_id) AS periods
FROM Faculty f
LEFT JOIN Subject s ON f.faculty_id = s.faculty_id
LEFT JOIN Schedule sc ON s.subject_id = sc.subject_id
GROUP BY f.faculty_id, f.faculty_name
ORDER BY f.faculty_id;

-- 12. QUERY 3: ROOM OCCUPANCY
SELECT
    r.room_name,
    COUNT(sc.slot_id) AS allocated_slots
FROM Room r
LEFT JOIN Schedule sc ON r.room_id = sc.room_id
GROUP BY r.room_id, r.room_name
ORDER BY r.room_id;

-- 13. QUERY 4: CHECK ROOM CONFLICTS
SELECT
    room_id,
    day_name,
    period_no,
    COUNT(*) AS clash_count
FROM Schedule
GROUP BY room_id, day_name, period_no
HAVING COUNT(*) > 1;

-- 14. PRACTICE QUERY 1: DISPLAY FACULTY TIMETABLE
SELECT
    f.faculty_name,
    sc.day_name,
    sc.period_no,
    s.subject_name,
    sc.section_name,
    r.room_name
FROM Faculty f
JOIN Subject s ON f.faculty_id = s.faculty_id
JOIN Schedule sc ON s.subject_id = sc.subject_id
JOIN Room r ON sc.room_id = r.room_id
ORDER BY f.faculty_name, sc.day_name, sc.period_no;

-- 15. PRACTICE QUERY 2: LIST FREE ROOMS FOR MONDAY PERIOD 2
SELECT
    room_id,
    room_name
FROM Room
WHERE room_id NOT IN (
    SELECT room_id
    FROM Schedule
    WHERE day_name = 'Monday'
      AND period_no = 2
);

-- 16. PRACTICE QUERY 3: COUNT PERIODS PER SECTION
SELECT
    section_name,
    COUNT(*) AS total_periods
FROM Schedule
GROUP BY section_name;

-- 17. PRACTICE QUERY 4: ADD A WEDNESDAY CLASS
INSERT INTO Schedule VALUES
(105, 12, 1, 'Wednesday', 1, 'CSE-A');

-- 18. PRACTICE QUERY 5: DETECT FACULTY DOUBLE-BOOKING
SELECT
    f.faculty_name,
    sc.day_name,
    sc.period_no,
    COUNT(*) AS clash_count
FROM Schedule sc
JOIN Subject s ON sc.subject_id = s.subject_id
JOIN Faculty f ON s.faculty_id = f.faculty_id
GROUP BY f.faculty_id, f.faculty_name, sc.day_name, sc.period_no
HAVING COUNT(*) > 1;

-- 19. ADD A VALID FACULTY RECORD
INSERT INTO Faculty VALUES
(4, 'Dr Sharma');

-- 20. MODIFY AN EXISTING ROOM RECORD
UPDATE Room
SET capacity = 65
WHERE room_id = 1;

-- 21. VALIDATE TABLES
SHOW TABLES;

-- 22. CHECK RECORD COUNTS
SELECT COUNT(*) AS faculty_count FROM Faculty;
SELECT COUNT(*) AS subject_count FROM Subject;
SELECT COUNT(*) AS room_count FROM Room;
SELECT COUNT(*) AS schedule_count FROM Schedule;

-- 23. DISPLAY ALL RECORDS
SELECT * FROM Faculty;
SELECT * FROM Subject;
SELECT * FROM Room;
SELECT * FROM Schedule;

-- 24. CHECK TABLE STRUCTURES
SHOW CREATE TABLE Faculty;
SHOW CREATE TABLE Subject;
SHOW CREATE TABLE Room;
SHOW CREATE TABLE Schedule;
