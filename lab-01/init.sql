SET NAMES utf8mb4;
USE lab; -- Или смени на ту базу, которую создал

-- 1. Таблица отделов (3НФ)
CREATE TABLE IF NOT EXISTS Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Таблица сотрудников (2НФ/3НФ)
CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Таблица квалификаций (1НФ - убираем списки через запятую)
CREATE TABLE IF NOT EXISTS EmployeeQualifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    qual_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- ЗАПОЛНЕНИЕ ДАННЫМИ
-- ==========================================

-- Заполняем отделы (без дублей)
INSERT INTO Departments (dept_id, dept_name) VALUES
(128, 'Отдел проектирования'),
(42, 'Финансовый отдел');

-- Заполняем сотрудников
INSERT INTO Employees (emp_id, full_name, position, dept_id) VALUES
(7513, 'Иванов Иван Иванович', 'Программист', 128),
(9842, 'Сергеева Светлана Сергеевна', 'Администратор БД', 42),
(6651, 'Петров Петр Петрович', 'Программист', 128),
(9006, 'Николаев Николай Николаевич', 'Системный администратор', 128);

-- Заполняем квалификации (разделяем те, что были через запятую)
INSERT INTO EmployeeQualifications (emp_id, qual_name) VALUES
(7513, 'C'), (7513, 'Java'),
(9842, 'DB2'),
(6651, 'VB'), (6651, 'Java'),
(9006, 'Windows'), (9006, 'Linux');
