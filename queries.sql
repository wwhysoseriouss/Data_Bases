-- Створення таблиці "Вчителі" (teachers)
CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    subject VARCHAR(100)
);

-- Створення таблиці "Класи" (classes)
CREATE TABLE classes (
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(10) NOT NULL,
    teacher_id INT,
    CONSTRAINT fk_teacher FOREIGN KEY(teacher_id) REFERENCES teachers(teacher_id)
);

-- Створення таблиці "Учні" (students)
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    class_id INT,
    CONSTRAINT fk_class FOREIGN KEY(class_id) REFERENCES classes(class_id)
);

-- Додаємо вчителів
INSERT INTO teachers (first_name, last_name, subject) VALUES
('Олена', 'Коваленко', 'Математика'),
('Іван', 'Петренко', 'Фізика'),
('Марія', 'Сидоренко', 'Історія');

-- Додаємо класи (прив'язуємо до них ID вчителів)
INSERT INTO classes (class_name, teacher_id) VALUES
('10-А', 1),
('10-Б', 2),
('11-А', 3);

-- Додаємо учнів (прив'язуємо до них ID класів)
INSERT INTO students (first_name, last_name, birth_date, class_id) VALUES
('Андрій', 'Шевченко', '2010-05-14', 1),
('Оксана', 'Бойко', '2010-08-22', 1),
('Дмитро', 'Ткаченко', '2010-11-03', 2),
('Анна', 'Мельник', '2009-02-15', 3);

-- Виводимо ім'я, прізвище учня та назву його класу
SELECT students.first_name, students.last_name, classes.class_name
FROM students
JOIN classes ON students.class_id = classes.class_id;

-- Змінюємо class_id для Дмитра
UPDATE students
SET class_id = 1
WHERE first_name = 'Дмитро' AND last_name = 'Ткаченко';

-- Видаляємо запис про Анну
DELETE FROM students
WHERE first_name = 'Анна' AND last_name = 'Мельник';
