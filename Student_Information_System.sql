-- STUDENT INFORMATION SYSTEM
-- EXPERIMENT 11: DBMS MINI-PROJECT 1

-- STEP 1: CREATE DATABASE

CREATE DATABASE IF NOT EXISTS Project1_StudentDB;
USE Project1_StudentDB;


-- STEP 2: CREATE DEPARTMENT TABLE

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL UNIQUE
);

INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'CSE'),
(2, 'ECE'),
(3, 'AIML');


-- STEP 3: CREATE STUDENT TABLE

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    dept_id INT NOT NULL,
    admission_year INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Student
(student_id, student_name, dept_id, admission_year) VALUES
(101, 'Arun', 1, 2024),
(102, 'Priya', 2, 2023),
(103, 'Sneha', 3, 2025),
(104, 'Ravi', 1, 2024);


-- STEP 4: CREATE COURSE TABLE

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits INT NOT NULL
);

INSERT INTO Course (course_id, course_name, credits) VALUES
(11, 'DBMS', 4),
(12, 'Data Structures', 4),
(13, 'AI Fundamentals', 3);


-- STEP 5: CREATE ENROLLMENT TABLE

CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    marks INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

INSERT INTO Enrollment (student_id, course_id, marks) VALUES
(101, 11, 88),
(102, 11, 91),
(103, 13, 94),
(104, 12, 75),
(101, 12, 82);


-- STEP 6: STUDENTS WITH DEPARTMENT DETAILS

SELECT s.student_id, s.student_name, d.dept_name
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
ORDER BY s.student_id;


-- STEP 7: COURSE ENROLLMENT DETAILS

SELECT s.student_name, c.course_name, e.marks
FROM Enrollment e
JOIN Student s ON s.student_id = e.student_id
JOIN Course c ON c.course_id = e.course_id
ORDER BY s.student_id, c.course_id;


-- STEP 8: AVERAGE MARKS BY COURSE

SELECT c.course_name,
       ROUND(AVG(e.marks), 2) AS avg_marks
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;


-- STEP 9: STUDENTS SCORING ABOVE 85

SELECT DISTINCT s.student_name
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.marks > 85
ORDER BY s.student_name;


-- STEP 10: STUDENTS NOT ENROLLED IN ANY COURSE

SELECT s.student_id, s.student_name
FROM Student s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


-- STEP 11: DISPLAY COURSES BY CREDITS

SELECT course_id, course_name, credits
FROM Course
ORDER BY credits DESC;


-- STEP 12: COUNT ENROLLMENTS BY DEPARTMENT

SELECT d.dept_name, COUNT(e.course_id) AS total_enrollments
FROM Department d
JOIN Student s ON d.dept_id = s.dept_id
LEFT JOIN Enrollment e ON s.student_id = e.student_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id;


-- STEP 13: STUDENTS SCORING BELOW 80

SELECT s.student_name, c.course_name, e.marks
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
WHERE e.marks < 80;


-- STEP 14: HIGHEST MARK PER COURSE

SELECT c.course_name, MAX(e.marks) AS highest_marks
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_id;


-- STEP 15: VERIFY TABLES

SHOW TABLES;

SELECT COUNT(*) AS Total_Departments FROM Department;
SELECT COUNT(*) AS Total_Students FROM Student;
SELECT COUNT(*) AS Total_Courses FROM Course;
SELECT COUNT(*) AS Total_Enrollments FROM Enrollment;

SHOW CREATE TABLE Department;
SHOW CREATE TABLE Student;
SHOW CREATE TABLE Course;
SHOW CREATE TABLE Enrollment;
