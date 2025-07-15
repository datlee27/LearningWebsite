
USE learning_management;

CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('student', 'teacher', 'admin') NOT NULL
);

CREATE TABLE Courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Users(id)
);

CREATE TABLE Lectures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    title VARCHAR(100) NOT NULL,
    video_url VARCHAR(255) NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

CREATE TABLE Assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    lecture_id INT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    due_date DATETIME,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    FOREIGN KEY (lecture_id) REFERENCES Lectures(id)
);

CREATE TABLE Submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    student_id INT,
    file_url VARCHAR(255),
    submission_date DATETIME,
    grade DECIMAL(4,2),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(id),
    FOREIGN KEY (student_id) REFERENCES Users(id)
);

CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

CREATE TABLE user_activity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    login_time DATETIME NOT NULL,
    logout_time DATETIME,
    duration_minutes INT
);
-- Sample data
INSERT INTO Users (username, password, email, role) VALUES
('admin', '$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2', 'admin@example.com', 'admin'),
('teacher1', '$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2', 'teacher1@example.com', 'teacher'),
('student1', '$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2', 'student1@example.com', 'student');