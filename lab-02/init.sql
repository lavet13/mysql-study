SET NAMES utf8mb4;
USE lab;

-- ============================================================
-- База данных STUDENT
-- Создаётся для лабораторных работ №2–11
-- Схема соответствует диаграмме из методического пособия
-- ============================================================

-- 1. Регионы (справочник — 3НФ)
CREATE TABLE IF NOT EXISTS region (
    kod_region INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie   VARCHAR(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Города (зависят от региона — 3НФ)
CREATE TABLE IF NOT EXISTS gorod (
    kod_gorod  INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie   VARCHAR(25) NOT NULL,
    kod_region INT NOT NULL,
    FOREIGN KEY (kod_region) REFERENCES region(kod_region) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Улицы (зависят от города — 3НФ)
CREATE TABLE IF NOT EXISTS ulica (
    kod_ulica INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie  VARCHAR(25) NOT NULL,
    kod_gorod INT NOT NULL,
    FOREIGN KEY (kod_gorod) REFERENCES gorod(kod_gorod) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Специальности (справочник — 3НФ)
CREATE TABLE IF NOT EXISTS spec (
    kod_spec INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie VARCHAR(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Учебные группы (зависят от специальности — 3НФ)
CREATE TABLE IF NOT EXISTS gruppa (
    kod_gruppy INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie   VARCHAR(20) NOT NULL,
    kod_spec   INT NOT NULL,
    FOREIGN KEY (kod_spec) REFERENCES spec(kod_spec) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Студенты (основная таблица — 3НФ)
CREATE TABLE IF NOT EXISTS dannie (
    kod_student  INT PRIMARY KEY AUTO_INCREMENT,
    fam          VARCHAR(20) NOT NULL,
    ima          VARCHAR(20) NOT NULL,
    otch         VARCHAR(20) NOT NULL,
    date_rognen  DATE,
    pasp_dannie  VARCHAR(50),
    telephone    VARCHAR(15),
    dom          VARCHAR(5),
    kvart        VARCHAR(5),
    kod_gruppy   INT,
    kod_ulica    INT,
    FOREIGN KEY (kod_gruppy) REFERENCES gruppa(kod_gruppy) ON DELETE SET NULL,
    FOREIGN KEY (kod_ulica)  REFERENCES ulica(kod_ulica)   ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Родители (справочник — 3НФ)
CREATE TABLE IF NOT EXISTS roditeli (
    kod_roditel INT PRIMARY KEY AUTO_INCREMENT,
    fio_rod     VARCHAR(100) NOT NULL,
    rabota      VARCHAR(100),
    tel         VARCHAR(15)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Связь студентов и родителей (многие ко многим — 2НФ)
CREATE TABLE IF NOT EXISTS roddeti (
    kod_student INT NOT NULL,
    kod_roditel INT NOT NULL,
    PRIMARY KEY (kod_student, kod_roditel),
    FOREIGN KEY (kod_student) REFERENCES dannie(kod_student)     ON DELETE CASCADE,
    FOREIGN KEY (kod_roditel) REFERENCES roditeli(kod_roditel)   ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Преподаватели (справочник — 3НФ)
CREATE TABLE IF NOT EXISTS prepod (
    kod_prepod  INT PRIMARY KEY AUTO_INCREMENT,
    fio_prepod  VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Дисциплины (зависят от специальности — 3НФ)
CREATE TABLE IF NOT EXISTS dischiplina (
    kod_dischiplina INT PRIMARY KEY AUTO_INCREMENT,
    nazvanie        VARCHAR(20) NOT NULL,
    kod_spec        INT,
    FOREIGN KEY (kod_spec) REFERENCES spec(kod_spec) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Успеваемость (связующая таблица — 2НФ)
CREATE TABLE IF NOT EXISTS uspev (
    ocenka          INT NOT NULL,
    kod_dischiplina INT NOT NULL,
    kod_student     INT NOT NULL,
    kod_prepod      INT NOT NULL,
    FOREIGN KEY (kod_dischiplina) REFERENCES dischiplina(kod_dischiplina) ON DELETE CASCADE,
    FOREIGN KEY (kod_student)     REFERENCES dannie(kod_student)          ON DELETE CASCADE,
    FOREIGN KEY (kod_prepod)      REFERENCES prepod(kod_prepod)           ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ЗАПОЛНЕНИЕ ДАННЫМИ
-- ============================================================

INSERT INTO region (nazvanie) VALUES
('Краснодарский край'),
('Ставропольский край'),
('Ростовская область');

INSERT INTO gorod (nazvanie, kod_region) VALUES
('Краснодар',    1),
('Армавир',      1),
('Новороссийск', 1),
('Ставрополь',   2),
('Пятигорск',    2),
('Ростов-на-Дону', 3);

INSERT INTO ulica (nazvanie, kod_gorod) VALUES
('Ставропольская', 1),
('Комсомольская',  1),
('Красная',        1),
('Мира',           2),
('Ставропольская', 2),
('Советская',      3),
('Ленина',         4),
('Комсомольская',  4),
('Пушкина',        5),
('Мира',           6);

INSERT INTO spec (nazvanie) VALUES
('МФ-МАТ'),
('МФ-ПИЭ'),
('МФ-Инф');

INSERT INTO gruppa (nazvanie, kod_spec) VALUES
('МФ-МАТ-4-1', 1),
('МФ-ПИЭ-4-1', 2),
('МФ-Инф-4-1', 3),
('МФ-МАТ-4-2', 1);

INSERT INTO prepod (fio_prepod) VALUES
('Иванов И.И.'),
('Плюшкин П.П.'),
('Сидоров С.С.'),
('Петров П.П.');

INSERT INTO dischiplina (nazvanie, kod_spec) VALUES
('Базы данных',        2),
('Программирование',   3),
('Математика',         1),
('Информатика',        3),
('Экономика',          2);

INSERT INTO dannie (fam, ima, otch, date_rognen, pasp_dannie, telephone, dom, kvart, kod_gruppy, kod_ulica) VALUES
('Марков',    'Иван',      'Петрович',    '1991-03-15', '0301 123456', '89181234567', '5',  '12', 1, 1),
('Иванов',    'Петр',      'Сергеевич',   '1990-07-22', '0301 234567', '89281234567', '10', '34', 1, 2),
('Климова',   'Анна',      'Ивановна',    '1991-11-05', '0302 345678', '89051234567', '3',  '7',  2, 3),
('Петров',    'Сергей',    'Александрович','1990-04-18', '0301 456789', '89181234568', '7',  NULL, 2, 4),
('Смелов',    'Дмитрий',   'Владимирович','1991-08-30', '0303 567890', '89281234568', '15', '22', 3, 5),
('Варечкин',  'Алексей',   'Николаевич',  '1990-12-01', '0301 678901', NULL,          '2',  '5',  3, 6),
('Котенко',   'Мария',     'Сергеевна',   '1991-06-14', '0302 789012', '89051234569', '8',  '19', 4, 1),
('Климов',    'Андрей',    'Петрович',    '1990-09-25', '0301 890123', '89181234570', '4',  '8',  1, 7),
('Нагорный',  'Виктор',    'Иванович',    '1991-02-17', '0303 901234', '89281234570', '6',  NULL, 2, 8),
('Старова',   'Елена',     'Дмитриевна',  '1991-05-03', '0301 012345', '89051234571', '11', '31', 3, 9);

INSERT INTO roditeli (fio_rod, rabota, tel) VALUES
('Марков Петр Иванович',      'Водитель',   '89181112233'),
('Маркова Ольга Сидоровна',   'Учитель',    '89282223344'),
('Иванов Петр Семенович',     'Врач',       '89053334455'),
('Иванова Нина Петровна',     'Повар',      '89184445566'),
('Климов Иван Степанович',    'Водитель',   '89285556677'),
('Климова Вера Алексеевна',   'Учитель',    '89056667788'),
('Петров Александр Иванович', 'Инженер',    '89187778899'),
('Смелов Владимир Петрович',  'Водитель',   '89288889900'),
('Варечкин Николай Иванович', NULL,         '89059990011'),
('Нагорный Иван Витальевич',  'Учитель',    '89181001122');

INSERT INTO roddeti (kod_student, kod_roditel) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7),
(5, 8),
(6, 9),
(9, 10);

INSERT INTO uspev (ocenka, kod_dischiplina, kod_student, kod_prepod) VALUES
(5, 1, 1, 1), (4, 2, 1, 2), (3, 3, 1, 3),
(4, 1, 2, 1), (5, 2, 2, 2), (4, 4, 2, 4),
(3, 1, 3, 1), (4, 2, 3, 2), (5, 5, 3, 3),
(2, 1, 4, 1), (3, 2, 4, 2), (4, 3, 4, 3),
(5, 1, 5, 1), (5, 4, 5, 4), (4, 5, 5, 3),
(3, 2, 6, 2), (2, 3, 6, 3), (3, 4, 6, 4),
(4, 1, 7, 1), (5, 2, 7, 2), (4, 3, 7, 3),
(5, 1, 8, 1), (4, 2, 8, 2), (3, 4, 8, 4),
(4, 5, 9, 3), (5, 3, 9, 3), (4, 1, 9, 1),
(3, 2, 10, 2),(4, 4, 10, 4),(5, 5, 10, 3);
