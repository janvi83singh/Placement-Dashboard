CREATE DATABASE PlacementDB;
USE PlacementDB;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    branch VARCHAR(50),
    cgpa DECIMAL(3,2),
    graduation_year INT,
    email VARCHAR(100)
);

CREATE TABLE Companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    industry VARCHAR(50),
    package DECIMAL(10,2)
);

CREATE TABLE Drives (
    drive_id INT PRIMARY KEY,
    company_id INT,
    drive_date DATE,
    role VARCHAR(50),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Applications (
    application_id INT PRIMARY KEY,
    student_id INT,
    drive_id INT,
    status VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (drive_id) REFERENCES Drives(drive_id)
);

-- Students
INSERT INTO Students VALUES
(1, 'Amit', 'IT', 8.5, 2024, 'amit@gmail.com'),
(2, 'Neha', 'CS', 9.1, 2024, 'neha@gmail.com'),
(3, 'Rahul', 'EXTC', 7.8, 2024, 'rahul@gmail.com'),
(4, 'Priya', 'IT', 8.9, 2024, 'priya@gmail.com'),
(5, 'Karan', 'CS', 7.5, 2024, 'karan@gmail.com');

-- Companies
INSERT INTO Companies VALUES
(101, 'TCS', 'IT', 350000),
(102, 'Infosys', 'IT', 400000),
(103, 'Amazon', 'Product', 1200000),
(104, 'Wipro', 'IT', 300000);

-- Drives (IMPORTANT: company_id must exist)
INSERT INTO Drives VALUES
(201, 101, '2024-05-10', 'Developer'),
(202, 102, '2024-05-12', 'Analyst'),
(203, 103, '2024-05-15', 'SDE'),
(204, 104, '2024-05-18', 'Engineer');

-- Applications (IMPORTANT: student_id & drive_id must exist)
INSERT INTO Applications VALUES
(301, 1, 201, 'Selected'),
(302, 2, 202, 'Selected'),
(303, 3, 201, 'Rejected'),
(304, 4, 203, 'Selected'),
(305, 5, 204, 'Rejected'),
(306, 1, 202, 'Selected'),
(307, 2, 203, 'Selected');

CREATE VIEW Dashboard_KPI AS
SELECT 
    (SELECT COUNT(*) FROM Students) AS total_students,
    (SELECT COUNT(*) FROM Companies) AS total_companies,
    (SELECT COUNT(*) FROM Applications WHERE status = 'Selected') AS students_placed,
    (SELECT MAX(package) FROM Companies) AS highest_package;
    
CREATE VIEW Placement_Status AS
SELECT 
    status,
    COUNT(*) AS total
FROM Applications
GROUP BY status;

CREATE VIEW Company_Placement AS
SELECT 
    c.company_name,
    COUNT(a.student_id) AS placed_students
FROM Applications a
JOIN Drives d ON a.drive_id = d.drive_id
JOIN Companies c ON d.company_id = c.company_id
WHERE a.status = 'Selected'
GROUP BY c.company_name;

CREATE VIEW Placement_Trend AS
SELECT 
    d.drive_date,
    COUNT(a.student_id) AS placements
FROM Applications a
JOIN Drives d ON a.drive_id = d.drive_id
WHERE a.status = 'Selected'
GROUP BY d.drive_date
ORDER BY d.drive_date;

CREATE VIEW Branch_Placement AS
SELECT 
    s.branch,
    COUNT(a.student_id) AS placed_students
FROM Students s
JOIN Applications a ON s.student_id = a.student_id
WHERE a.status = 'Selected'
GROUP BY s.branch;

CREATE VIEW Top_Companies AS
SELECT company_name, package
FROM Companies
ORDER BY package DESC;

CREATE VIEW Student_Ranking AS
SELECT 
    name,
    branch,
    cgpa,
    RANK() OVER (ORDER BY cgpa DESC) AS rank_position
FROM Students;

SELECT 
    s.branch,
    COUNT(CASE WHEN a.status = 'Selected' THEN 1 END) AS placed,
    COUNT(CASE WHEN a.status = 'Rejected' THEN 1 END) AS rejected,
    AVG(s.cgpa) AS avg_cgpa
FROM Students s
LEFT JOIN Applications a 
ON s.student_id = a.student_id
GROUP BY s.branch;