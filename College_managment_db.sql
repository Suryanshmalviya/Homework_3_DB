CREATE DATABASE College_Managment;
USE college_managment;

CREATE TABLE Students (
    student_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    program VARCHAR(50) NOT NULL
);
INSERT INTO students 
(student_id, name, email, program)
VALUES 
('STU001', 'Suryansh Malviya', 'suryanshmalviya870@email.com', 'Software Engineering'),
('STU002', 'Suraj Sharma', 'surajsharma@email.com', 'Computer Science'),
('STU003', 'Tushar Prajapati', 'tusharprajapati@email.com', 'Data Science'),
('STU004', 'Karan Parmar', 'karanparmar@email.com', 'Computer Science'),
('STU005', 'Aditya Paliwal', 'adityapaliwal@email.com', 'Software Engineering');

select * from students;

CREATE TABLE Instructors (
    instructor_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);
INSERT INTO Instructors 
(instructor_id, name, department)
VALUES 
('INST01', 'dr. Harsha Meena', 'Computer Science'),
('INST02', 'prof. Gayatri Lodhi', 'Data Science'),
('INST03', 'Assi_Prof. Anshul Gupta', 'Software Engineering');

select * from instructors;

CREATE TABLE Courses (
    course_id VARCHAR(100) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    instructor_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);
INSERT INTO Courses 
(course_id, title, credits, instructor_id)
VALUES 
('CS101', 'Introduction to Database Systems', 3, 'INST01'),
('CS201', 'Data Structures and Algorithms', 4, 'INST01'),
('DS301', 'Machine Learning Fundamentals', 3, 'INST02'),
('SE401', 'Software Development', 4, 'INST03');

select * from courses;

CREATE TABLE Enrollments (
    enrollment_id VARCHAR(100) PRIMARY KEY,
    student_id VARCHAR(100) NOT NULL,
    course_id VARCHAR(100) NOT NULL,
    semester VARCHAR(100) NOT NULL CHECK (semester IN ('Spring', 'Summer', 'Fall')),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
INSERT INTO Enrollments 
(enrollment_id, student_id, course_id, semester)
VALUES 
('ENR001', 'STU001', 'CS101', 'Fall'),
('ENR002', 'STU001', 'CS201', 'Fall'),
('ENR003', 'STU002', 'CS101', 'Fall'),
('ENR004', 'STU002', 'CS201', 'Fall'),
('ENR005', 'STU003', 'DS301', 'Summer'),
('ENR006', 'STU004', 'CS101', 'Fall'),
('ENR007', 'STU004', 'CS201', 'Fall'),
('ENR008', 'STU005', 'SE401', 'Spring');

select * from enrollments;

CREATE TABLE Assessments (
    assessment_id VARCHAR(100) PRIMARY KEY,
    course_id VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL CHECK (type IN ('Assignment', 'Exam', 'Quiz', 'Project')),
    max_marks DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
INSERT INTO Assessments 
(assessment_id, course_id, type, max_marks)
VALUES 
('ASM001', 'CS101', 'Assignment', 50),
('ASM002', 'CS101', 'Exam', 100),
('ASM003', 'CS201', 'Assignment', 50),
('ASM004', 'CS201', 'Exam', 70),
('ASM005', 'DS301', 'Project', 100),
('ASM006', 'SE401', 'Project', 100);

select * from assessments;

CREATE TABLE Grades (
    grade_id VARCHAR(100) PRIMARY KEY,
    enrollment_id VARCHAR(100) NOT NULL,
    assessment_id VARCHAR(100) NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id),
    FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id),
    CONSTRAINT chk_marks CHECK (marks_obtained >= 0)
);
INSERT INTO Grades 
(grade_id, enrollment_id, assessment_id, marks_obtained)
VALUES 
('GRD001', 'ENR001', 'ASM001', 92.50),
('GRD002', 'ENR001', 'ASM002', 88.00),
('GRD003', 'ENR002', 'ASM003', 95.00),
('GRD004', 'ENR002', 'ASM004', 91.50),
('GRD005', 'ENR003', 'ASM001', 78.00),
('GRD006', 'ENR004', 'ASM003', 85.50),
('GRD007', 'ENR004', 'ASM004', 80.00),
('GRD008', 'ENR005', 'ASM005', 94.00),
('GRD009', 'ENR006', 'ASM001', 70.00),
('GRD010', 'ENR007', 'ASM003', 82.00);

select * from Grades;

-- 10. Display all students enrolled in a given course (use JOIN). 
SELECT *
FROM enrollments
INNER JOIN courses
ON enrollments.course_id = courses.course_id;

SELECT *
FROM Students s
INNER JOIN Enrollments e 
ON s.student_id = e.student_id;

-- 11. Find the average marks for each course. 
SELECT 
    c.course_id,
    c.title,
    ROUND(AVG(g.marks_obtained), 2) AS average_marks
FROM Courses c
INNER JOIN Assessments a ON c.course_id = a.course_id
INNER JOIN Grades g ON a.assessment_id = g.assessment_id
GROUP BY c.course_id, c.title
ORDER BY average_marks DESC;

-- 12. List students who scored above the overall average. 
SELECT 
    s.student_id,
    s.name,
    ROUND(AVG(g.marks_obtained), 2) AS personal_average
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.name
HAVING AVG(g.marks_obtained) > (
    SELECT AVG(marks_obtained) 
    FROM Grades
)
ORDER BY personal_average DESC;

-- 13. Show the top 3 highest scoring students in a specific course. 
SELECT 
    s.student_id,
    s.name,
    ROUND(AVG(g.marks_obtained), 2) AS course_average
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Grades g ON e.enrollment_id = g.enrollment_id
WHERE e.course_id = 'CS201'
GROUP BY s.student_id, s.name
ORDER BY course_average DESC
LIMIT 3;

-- 14. Count how many students each instructor is teaching. 
SELECT 
    i.instructor_id,
    i.name,
    i.department,
    COUNT(DISTINCT e.student_id) AS students_count
FROM Instructors i
INNER JOIN Courses c ON i.instructor_id = c.instructor_id
INNER JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY i.instructor_id, i.name, i.department
ORDER BY students_count DESC;

-- 15. Display courses that currently have no enrollments (use LEFT JOIN). 
SELECT *
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- 16. Write a transaction to enroll a student into a course and insert an initial grade record.
START TRANSACTION;
INSERT INTO Enrollments (enrollment_id, student_id, course_id, semester)
VALUES ('ENR009', 'STU005', 'CS101', 'Fall');

INSERT INTO Grades (grade_id, enrollment_id, assessment_id, marks_obtained)
VALUES ('GRD011', 'ENR009', 'ASM001', 0.00);
COMMIT;

SELECT * FROM Enrollments WHERE enrollment_id = 'ENR009';
SELECT * FROM Grades WHERE grade_id = 'GRD011';

-- 17. Demonstrate a ROLLBACK when an invalid grade (e.g., 150 marks) is attempted. 
START TRANSACTION;
INSERT INTO Grades (grade_id, enrollment_id, assessment_id, marks_obtained)
VALUES ('GRD012', 'ENR009', 'ASM001', 150.00);
ROLLBACK;

SELECT * FROM Grades WHERE grade_id = 'GRD012';
