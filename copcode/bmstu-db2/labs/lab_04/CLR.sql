create extension plpython3u

-- 1 - определяемая пользователем скалярную функция CLR
-- вощвращает 1, если в указанную дату прозодил экзамен
drop function studentGrade(student_tab student)

create or replace function studentGrade(student_tab student)
returns text as 
$$
	grade = ''
	form = student_tab['form']
	if form >= 1 and form <= 3:
		grade = 'младшие классы'
	elif form > 5:
		grade = 'старшие классы'
	else:
		grade = 'средние классы'
	return grade
$$
language plpython3u

select fullname, studentGrade(student.*) as grade
from student

-- 2 - пользовательская агрегатная функция CLR
-- количество учеников, играющих на определенном инструменте
drop function specialityCount(spec varchar)

create or replace function specialityCount(spec varchar)
returns int as 
$$
	students = plpy.execute("select * from student")
	cnt = 0
	for elem in students:
		if elem["speciality"] == spec:
			cnt += 1	
	return cnt
$$
language plpython3u

select distinct speciality, specialityCount(speciality)
from student

-- 3 - определяемая пользоателем табличная функция CLR
-- экзамены определенного ученика
drop function conStudentExam(sid int)

create or replace function conStudentExam(sid int)
returns table (studid int, student text, teacher text, composition text, mark integer, date date) as
$$
	res = []
	exams = plpy.execute("select s.id as studid, s.fullname as student,\
		t.fullname as teacher, title as composition, mark, date\
		from exam e join student s on e.studentid = s.id\
		join teacher t on e.teacherid = t.id join\
		composition c on e.compositionid = c.id")
	for elem in exams:
		if elem["studid"] == sid:
			res.append(elem)
	return res
$$
language plpython3u

select *
from conStudentExam(9)

-- 4 - хранимая процедура CLR
-- обновление тональности произведений конкретного автора
drop procedure updateTonality(composerid int)

create or replace procedure updateTonality(composerid int)
as
$$
	plpy.execute("update sc1.composition\
		set tonality = 'D-dur'\
		where composerid = " + str(composerid))
$$
language plpython3u

call updateTonality(14)

select *
from composition c 
where composerid = 14

-- 5 - триггер CLR
-- текстовое сообщение когда добавляетя новый ученик
drop function studentInsertMsg()

drop trigger newStudent on sc1.student 
--'A new student was added!'

create or replace function studentInsertMsg()
returns trigger as 
$$
	plpy.notice('A new student was added!')
	return "OK"
$$
language plpython3u

create trigger newStudent
after insert 
on sc1.student 
execute function studentInsertMsg()

delete from sc1.student 
where id = 1002

insert into sc1.student (fullname, gender, form, speciality, friend)
values ('Трещеточник М. Е.', 'male', '3', 'просто трещетки', '11')

-- 6 - определяемый пользователем тип данных CLR
-- тип композиция - только название и автор
create type compComp as
(
	title varchar,
	composer varchar
);

drop function getShortCompositionInfo(compId int)

create or replace function getShortCompositionInfo(compid int)
returns compComp as
$$
	dt = plpy.execute("select title, fullname\
		from composition c join composer cr on c.composerid = cr.id\
		where c.id = " + str(compid))
	return (dt[0]["title"], dt[0]["fullname"])
$$
language plpython3u

select *
from getShortCompositionInfo(14)


