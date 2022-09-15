-- 1 - Скалярная функция
-- возвращает среднюю оценку экзаменов студентов между id1 и id2
drop function avgexammark(int, int)

create or replace function avgexammark(integer, integer)
returns real as
$$
declare
	avgMark real;
begin
	select avg(mark) from sc1.exam into avgMark where studentid between $1 and $2;
	return avgMark;
end
$$
language plpgsql

select distinct avgexammark(5, 15)

select * from conteacherexam(7)

insert into sc1.contest (title, city, level)
values('Волшебный микрофон', 'Москва', 3)

-- 2 - Подставляемая табличная функция
-- возвращает джойны таблиц по связке-экзамену
create or replace function examList()
returns table(student text, teacher text, composition text, mark integer) as
$$
begin
	return query select s.fullname, t.fullname, cmp.title, e.mark
	from sc1.exam e join sc1.teacher t on e.teacherid = t.id 
	join sc1.student s on e.studentid = s.id
	join sc1.composition cmp on e.compositionid = cmp.id;
end
$$
language plpgsql

select *
from examList()

-- 3 - Многооператорная табличная функция
-- изменяет оценки от преподавателя tid с 3 на 5 и удаляет оценки 2, выводит результирующую таблицу
create or replace function conTeacherExam(tid int)
returns table(student text, teacher text, composition text, marks integer) as
$$
begin
	update sc1.exam 
	set mark = 5
	where teacherid = tid and mark = 3;

	delete from sc1.exam
	where teacherid = tid and mark = 2;
	
	return query select s.fullname, t.fullname, cmp.title, e.mark
	from sc1.exam e join sc1.teacher t on e.teacherid = t.id 
	join sc1.student s on e.studentid = s.id
	join sc1.composition cmp on e.compositionid = cmp.id
	where e.teacherid = tid;
end
$$
language plpgsql

select *
from conTeacherExam(15)

-- 4 - Рекурсивная функция или функция с рекурсивным ОТВ
-- самый далекий друг ученика
create or replace function stFriends(sid int, lf int)
returns int as
$$
declare
	res int;
begin
	select stFriends(friend, friend)
	from sc1.student into res
	where id = sid and friend is not null;
	if res is null then
		return lf;
	else
		return res;
	end if;
end
$$
language plpgsql

select id as studentId, stFriends(id, friend) as farFriend
from sc1.student
where friend is not null

alter table sc1.student 
add column friend int references sc1.student (id)

-- 5 - Хранимая процедура без/с параметрами
-- обновление тональности произведений автора 840
drop procedure rewriteTonality(cid int)

create or replace procedure rewriteTonality(cid integer)
as
$$
begin
	update sc1.composition 
	set tonality = 'D#-dur'
	where composerid = cid;
end
$$
language plpgsql

call rewriteTonality(105)

select *
from sc1.composition
where composerid = 105

-- 6 - Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
-- выставляет инструмент валторна всем, кто дружит с 3, в том числе через других друзей
drop procedure stFriendsDepth(sid int)

create procedure stFriendsDepth(sid int)
as 
$$
declare 
	nextFriend int;
begin 
	select distinct friend
	from sc1.student into nextFriend
	where id = sid;
	
	update sc1.student 
	set speciality = 'валторна'
	where id = sid;

	if nextFriend is not null then
		call stFriendsDepth(nextFriend);
	end if;
end
$$
language plpgsql

call stFriendsDepth(3)

-- 7 - Хранимая процедура с курсором
-- отличие от средней оценки по ноябрю за экзамены от 10 до 100
drop procedure novExam()

create procedure novExam()
as 
$$
declare 
	examDateCursor cursor for select studentid, mark from sc1.exam where date::text like '%-11-%' and id between 10 and 100;
	sid int;
	examMark int;
	sumMark int;
	countMark int;
	res real;
begin 
	countMark = 0;
	open examDateCursor;
	loop
	fetch examDateCursor into sid, examMark;
	sumMark = sumMark + examMark;
	countMark = countMark + 1;
	end loop;
	close examDateCursor;
	res = sumMark - sumMark / countMark;
	raise notice 'Out of average mark on November: %', res;
end
$$
language plpgsql

call novExam()

select *
from sc1.exam
where date::text like '2021-%'

-- 8 - Хранимая процедура доступа к метаданным
-- кол-во ключей в таблицах (первичных и внешних)
create procedure countKeyColumns()
as 
$$
declare 
	res int;
begin 
	select count(*) into res
	from information_schema.key_column_usage;
	raise notice 'Count of key columns usages %', res;
end
$$
language plpgsql

call countKeyColumns()

select *
from information_schema.key_column_usage kcu 

select *
from information_schema."routines" r 
where routine_name = 'avgexammark'

-- 9 - Триггер AFTER
-- Текстовое сообщение при добавлении учителя в таблицу
drop function teacherInsertMsg()

create or replace function teacherInsertMsg()
returns trigger as 
$$
begin 
	raise notice 'A new teacher was added!';
	return new;
end
$$
language plpgsql

drop trigger newTeacher on sc1.teacher 

create trigger newTeacher
after insert 
on sc1.teacher 
execute function teacherInsertMsg()

insert into sc1.teacher (fullname, gender, age, education)
values ('Оао М. М.', 'female', '21', 'среднее')

-- 10 - Триггер INSTEAD OF
-- Откат обновления друга, если FK не существует
create view newFriend as
select *
from sc1.student
where friend is not null

update sc1.newFriend
set friend = 12300
where id = 5

select *
from sc1.newfriend

drop function insteadNewFriend()

create or replace function insteadNewFriend()
returns trigger as 
$$
begin 
	if new.friend not in (select id from sc1.student) then
		raise notice 'Wrong ID!';
		return null;
	else
		update sc1.student set friend = new.friend where id = old.id;
		raise notice 'A new friend was updated!';
		return new;
	end if;
end
$$
language plpgsql

drop trigger wrongNewFriend on sc1.newFriend

create trigger wrongNewFriend
instead of update 
on sc1.newFriend
for each row
execute function insteadNewFriend()