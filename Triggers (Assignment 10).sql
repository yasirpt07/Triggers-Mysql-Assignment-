use college;

CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

INSERT INTO teachers (id, name, subject, experience, salary) VALUES
(1, 'John Doe', 'Math', 8, 50000),
(2, 'Jane Smith', 'Science', 12, 60000),
(3, 'Alice Brown', 'English', 5, 45000),
(4, 'Mark Johnson', 'History', 15, 70000),
(5, 'Emily Davis', 'Physics', 3, 40000),
(6, 'Michael Wilson', 'Chemistry', 10, 55000),
(7, 'Laura Taylor', 'Biology', 2, 38000),
(8, 'James Anderson', 'Geography', 7, 48000);


-- teacher_log table
CREATE TABLE teacher_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT,
    action VARCHAR(50),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- before_insert_teacher trigger
DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$

DELIMITER ;

INSERT INTO teachers (id, name, subject, experience, salary) 
VALUES (10, 'Tony Stark', 'Engineering', 5, -5000);


-- after_insert_teacher trigger
DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, log_timestamp)
    VALUES (NEW.id, 'Insert', NOW());
END$$

DELIMITER ;

INSERT INTO teachers (id, name, subject, experience, salary) 
VALUES (11, 'Bruce Wayne', 'Business', 6, 60000);

SELECT * FROM teacher_log WHERE action = 'Insert';


-- before_delete_teacher trigger
DELIMITER $$

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete teachers with more than 10 years of experience';
    END IF;
END$$

DELIMITER ;

-- Jane Smith has 12 years of experience.
DELETE FROM teachers WHERE id = 2;  


-- after_delete_teacher trigger
DELIMITER $$

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, log_timestamp)
    VALUES (OLD.id, 'Delete', NOW());
END$$

DELIMITER ;

-- Alice Brown has 5 years of experience.
DELETE FROM teachers WHERE id = 3;  

SELECT * FROM teacher_log WHERE action = 'Delete';




