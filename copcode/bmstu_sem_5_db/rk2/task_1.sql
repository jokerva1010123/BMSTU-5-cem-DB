create database rk2;

--задание 1
create table teachers
(
	id int primary key,
	surname varchar,
	degree int,
	post varchar,
	department varchar
);

create table departments
(
	id int primary key,
	name varchar,
	description varchar,
	
	id_teachers int,
	foreign key(id_teachers) references teachers(id)
);

create table subjects
(
	id int primary key,
	name varchar,
	count_hours int,
	semester int,
	rate int
);

create table teachers_subjects
(
	id_teachers int,
	foreign key(id_teachers) references teachers(id),
	
	id_subject int,
	foreign key(id_subject) references subjects(id)
);

insert into teachers values
(1, 'Фамилия1', 1, 'Доцент', 'ИУ7'),
(2, 'Фамилия2', 2, 'Старший преподаватель', 'ИУ5'),
(3, 'Фамилия3', 3, 'Преподаватель', 'ИУ6'),
(4, 'Фамилия4', 2, 'Ассистент', 'ИУ4'),
(5, 'Фамилия5', 1, 'Доцент', 'ИУ4'),
(6, 'Фамилия6', 3, 'Старший преподаватель', 'ИУ5'),
(7, 'Фамилия7', 2, 'Преподаватель', 'ИУ6'),
(8, 'Фамилия8', 2, 'Ассистент', 'ИУ5'),
(9, 'Фамилия9', 3, 'Старший преподаватель', 'ИУ7'),
(10, 'Фамилия10', 1, 'Преподаватель', 'ИУ4');

insert into departments values
(1, 'name_1', 'description_1', 1),
(2, 'name_2', 'description_2', 3),
(3, 'name_4', 'description_3', 4),
(4, 'name_4', 'description_4', 5),
(5, 'name_5', 'description_5', 3),
(6, 'name_6', 'description_6', 2),
(7, 'name_7', 'description_7', 1),
(8, 'name_8', 'description_8', 4),
(9, 'name_9', 'description_9', 5),
(10, 'name_10', 'description_10', 6);

insert into subjects values
(1, 'subject_name_1', 70, 1, 5),
(2, 'subject_name_2', 80, 2, 4),
(3, 'subject_name_3', 140, 3, 3),
(4, 'subject_name_4', 70, 4, 5),
(5, 'subject_name_5', 80, 5, 4),
(6, 'subject_name_6', 140, 1, 5),
(7, 'subject_name_7', 70, 2, 5),
(8, 'subject_name_8', 80, 3, 4),
(9, 'subject_name_9', 140, 4, 4),
(10, 'subject_name_10', 70, 5, 4);

insert into teachers_subjects values
(1, 2),
(1, 3),
(2, 2),
(2, 3),
(3, 9),
(3, 8),
(4, 4),
(4, 10),
(4, 5),
(5, 7),
(5, 6),
(6, 6),
(6, 1),
(6, 5),
(7, 3),
(7, 4),
(7, 1),
(8, 9),
(8, 10),
(8, 1),
(9, 2),
(9, 3),
(10, 1),
(10, 2);

--задание 2
--инструкция select, использующая скалярные подзапросы в выражении столбцов
--сравнить количество часов дисциплины преподавателей, которые ее ведут, с максимальным по вузу
select surname, subjects.count_hours, (select max(count_hours)
				 						from teachers join teachers_subjects on teachers.id = teachers_subjects.id_teachers
							  			 join subjects on subjects.id = teachers_subjects.id_subject)
from teachers join teachers_subjects on teachers.id = teachers_subjects.id_teachers
							   join subjects on subjects.id = teachers_subjects.id_subject

--инструкция delete с вложенным коррелированным подзапросом в предложении where
--дисциплину с плохим рейтингом убрали; удалить всех преподавателей, которые вели ее
delete from teachers_subjects
where teachers_subjects.id_subject in (select subjects.id
					  					from subjects join teachers_subjects on subjects.id = teachers_subjects.id_subject
					  					where subjects.rate < 4)

--инструкция select, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении from
--вывести всех преподавателей, которые ведут дисциплины с рейтингом 5

select teachers.surname, T.rate
from teachers join (select teachers_subjects.id_teachers, subjects.name, subjects.rate 
				   	from subjects join teachers_subjects on subjects.id = teachers_subjects.id_subject
				    where subjects.rate = 5) as T on T.id_teachers = teachers.id


--задание 3
--Создать хранимую процедуру с входным параметром, которая выводит имена и описания типа
--объектов (только хранимых процедур и скалярных функций), в тексте которых на языке SQL
--встречается строка, задаваемая параметром процедуры. Созданную хранимую процедуру
--протестировать.

--для начала создадим функцию, чтобы были примеры
create function func_prob_1(input_name varchar)
returns integer as
$$
begin
	return 1;
end;
$$
language plpgsql;

--select func_prob_1('name');

create or replace procedure output_name_type_objects(input_str varchar)
as
$$
declare
	elem_1 varchar = '';
	elem_2 varchar = '';
begin
	for elem_1, elem_2 in
		select routines.routine_name, parameters.data_type
		from information_schema.routines
				join information_schema.parameters on routines.specific_name=parameters.specific_name
		where routines.specific_schema='public' and routine_definition like '%return%'
	loop
		raise notice 'Имя функции/процедуры: %, %', elem_1, elem_2; 
	end loop;
end;
$$
language plpgsql;

call output_name_type_objects('LIKE');