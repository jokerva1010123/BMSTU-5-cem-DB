DROP TABLE department, teachers, subject, ts;

CREATE TABLE IF NOT EXISTS department
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description VARCHAR(100) NOT NULL
);

INSERT INTO department(name, description) VALUES
('depart1', 'descr1'),
('depart2', 'descr2'),
('depart3', 'descr3'),
('depart4', 'descr4'),
('depart5', 'descr5'),
('depart6', 'descr6'),
('depart7', 'descr7'),
('depart8', 'descr8'),
('depart9', 'descr9'),
('depart10', 'descr10');

CREATE TABLE IF NOT EXISTS teachers
(
	id SERIAL PRIMARY KEY,
	FIO VARCHAR(100) NOT NULL,
	degree VARCHAR(100) NOT NULL,
	position VARCHAR(100) NOT NULL,
	depart_id SERIAL,
	FOREIGN KEY (depart_id) REFERENCES department(id)
);

INSERT INTO teachers(FIO, degree, position, depart_id) VALUES
('fio1', 'degree1', 'pos1', '10'),
('fio2', 'degree2', 'pos2', '10'),
('fio3', 'degree3', 'pos3', '9'),
('fio4', 'degree4', 'pos4', '9'),
('fio5', 'degree5', 'pos5', '6'),
('fio6', 'degree6', 'pos6', '5'),
('fio7', 'degree7', 'pos7', '4'),
('fio8', 'degree8', 'pos8', '3'),
('fio9', 'degree9', 'pos9', '2'),
('fio10', 'degree10', 'pos10', '1');

CREATE TABLE IF NOT EXISTS subject
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	hours INTEGER NOT NULL,
	semestr INTEGER NOT NULL,
	rating INTEGER NOT NULL
);

INSERT INTO subject(name, hours, semestr, rating) VALUES
('sub1', '1', '1', '1'),
('sub2', '2', '1', '2'),
('sub3', '3', '2', '3'),
('sub4', '5', '2', '4'),
('sub5', '5', '3', '5'),
('sub6', '5', '3', '6'),
('sub7', '7', '4', '7'),
('sub8', '8', '4', '8'),
('sub9', '9', '5', '9'),
('sub10', '10', '5', '10');

CREATE TABLE IF NOT EXISTS ts
(
	id SERIAL PRIMARY KEY,
	teacher_id SERIAL,
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	subject_id SERIAL,
	FOREIGN KEY (subject_id) REFERENCES subject(id)
);

INSERT INTO ts(teacher_id, subject_id) VALUES
('1', '10'),
('2', '9'),
('3', '8'),
('4', '7'),
('5', '6'),
('6', '1'),
('7', '2'),
('8', '3'),
('9', '4'),
('10', '5');

-- Вывести информацию о всех предметах
-- рейтинг которых, больше всех рейтингов
-- предметов с количеством часов, равным 5
SELECT *
FROM subject
WHERE rating > ALL(SELECT rating
				   FROM subject
				   WHERE hours = 5);

-- Посчитать общее число часов для 3 семестра.

SELECT SUM(hours) AS sum_hours
FROM subject
WHERE semestr = 3;

-- Создать таблицу преподавателей кафедры,
-- id которой равен 10.

SELECT FIO, degree, position
INTO teachers10
FROM teachers
WHERE depart_id = 10;
