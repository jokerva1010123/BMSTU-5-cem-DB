-- Задание 1 (8 баллов)
-- Создать базу данных и схему RK3. Создать в ней таблицы Преподаватели
create database rk;
\connect rk;

create schema rk3;

drop table if exists rk3.students;
drop table if exists rk3.teachers;

create table rk3.teachers (
	id           serial primary key,
	name         text,
	department   text,
	max_students smallint
);

create table rk3.students (
	id         serial primary key,
	name       text,
	birthday   date,
	department text,
	teacher_id int references rk3.teachers (id) null
);


-- Создать табличную функцию, подбирающу научного руководителя
-- не определившимся студентам, с учетом уже имеющейся занятости преподователя.
drop procedure if exists rk3.get_teachers_to_students();

create or replace procedure rk3.get_teachers_to_students() language plpgsql as $$
declare
	student record;
	teacher int;
begin
	for student in
		select *
		from rk3.students
		where teacher_id is null
	loop
		select rk3.teachers.id into teacher
		from rk3.teachers
			join rk3.students s on teachers.id = s.teacher_id
		group by teachers.id, max_students
		having count(s.id) < max_students
		limit 1;

		update rk3.students set teacher_id = teacher where id = student.id;
	end loop;
end
$$;

insert into rk3.teachers
	(name, department, max_students)
values
	('Рудаков Игорь Владимирович', 'ИУ7', 6),
	('Строганов Юрий Владимирович', 'ИУ7', 5),
	('Куров Андрей Владимирович', 'ИУ7', 6),
	('Скориков Татьяна Петровна', 'Л', 1);

insert into rk3.students
	(name, birthday, department, teacher_id)
values
	('Иванов Иван Иванович', '1990-09-25', 'ИУ', 1),
	('Петров Петр Петрович', '1987-11-12', 'Л', null),
	('Попов Поп Попович', '1998-01-02', 'ИУ', 3),
	('Попов Иван Иванович', '1998-01-03', 'РК', 2),
	('Иванов Петр Иванович', '1998-10-10', 'ИБМ', 1),
	('Иванов Иван Петрович', '1998-01-01', 'АК', null),
	('Керимов Иван Иванович', '1989-01-03', 'МТ', null),
	('Иванов Керим Иванович', '1988-01-10', 'МТ', null),
	('Иванов Иван Керимович', '1987-01-04', 'СК', 3),
	('Андреев Иван Иванович', '1986-04-01', 'Э', 1),
	('Иванов Андрей Иванович', '1985-03-01', 'Э', 1),
	('Иванов Иван Андреевич', '1984-02-01', 'Э', null);

call rk3.get_teachers_to_students();

select *
from rk3.students;
select rk3.teachers.id, (
	select count(*)
	from rk3.students
	where teacher_id = rk3.teachers.id
)
from rk3.teachers;
