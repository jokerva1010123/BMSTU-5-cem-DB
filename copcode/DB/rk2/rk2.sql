-- Задание 1 (4 балла)
-- Создать базу данных RK2. Создать в ней структуру, соответствующую
-- указанной на ER-диаграмме. Заполнить таблицы тестовыми значениями (не
-- менее 10 в каждой таблице).
drop database if exists rk2;
create database rk2;
\connect rk2

drop table if exists bouquets;
drop table if exists florists;
drop table if exists customers;
drop table if exists florists_customers;

create table florists (
	id       serial primary key,
	fullname text,
	passport text,
	phone    text
);

create table bouquets (
	id      serial primary key,
	author  serial not null references florists(id),
	name    text
);

create table customers (
	id       serial primary key,
	fullname text,
	birthday date,
	city     text,
	phone    text
);

create table florists_customers (
	id          serial primary key,
	florist_id  serial,
	customer_id serial
);

insert
into florists
(fullname, passport, phone)
values
	('Kerimov Ahmed Shakhovich', '4613248465', '89263889988'),
	('Zabitov Ahmed Shakhovich', '4613248466', '89263889989'),
	('Abramov Ahmed Shakhovich', '4613246465', '89263889980'),
	('Muslimov Ahmed Shakhovich', '4613238465', '89263889981'),
	('Bahromov Ahmed Shakhovich', '4613218465', '89263889982'),
	('Volkov Ahmed Shakhovich', '4613148465', '89263889983'),
	('Orlov Ahmed Shakhovich', '4613248445', '89263889984'),
	('Kraynov Ahmed Shakhovich', '4613240465', '89263889985'),
	('Kerimova Emina Shakhovna', '4613248405', '89263889986'),
	('Kerimova Elina Shakhovna', '4614248465', '89263889987');

insert
into customers
(fullname, birthday, city, phone)
values
	('Orlov Andrey Dmitrievich', '1999-1-1', 'Moscow', '89265289509'),
	('Zubov Andrey Dmitrievich', '1999-2-2', 'Moscow', '89265289500'),
	('Tarasov Andrey Dmitrievich', '1999-3-3', 'Moscow', '89265289501'),
	('Sardarov Andrey Dmitrievich', '1999-4-4', 'Moscow', '89265289502'),
	('Kekov Andrey Dmitrievich', '1999-10-10', 'Moscow', '89265289503'),
	('Kukov Andrey Dmitrievich', '1999-9-9', 'Moscow', '89265289504'),
	('Tassov Andrey Dmitrievich', '1999-8-8', 'Moscow', '89265289505'),
	('Bekasov Andrey Dmitrievich', '1999-7-7', 'Moscow', '89265289506'),
	('Babarykin Andrey Dmitrievich', '1999-6-6', 'Moscow', '89265289507'),
	('Popov Andrey Dmitrievich', '1999-5-5', 'Moscow', '89265289508');

insert
into florists_customers
(florist_id, customer_id)
values
	(1, 10),
	(2, 9),
	(3, 8),
	(4, 7),
	(5, 6),
	(6, 5),
	(7, 4),
	(8, 3),
	(9, 2),
	(10, 2);

insert
into bouquets
(author, name)
values
	(1, 'Romashka'),
	(3, 'Roza'),
	(5, 'Cvetoklol'),
	(7, 'Gvozdika'),
	(9, 'Liliya'),
	(1, 'Pion'),
	(4, 'Oduvanchick'),
	(6, 'Siren'),
	(8, 'Tulpan'),
	(10, 'Nezabudka');


-- Задание 2 (6 баллов)
-- Написать к разработанной базе данных 3 запроса, в комментарии указать, что
-- этот запрос делает:

-- Инструкция SELECT, использующая поисковое выражение CASE
-- id, fullname и кол-во букетов или 'No bouqets' из флористов
select florists.id, florists.fullname,
	case
		when (
			select count(*)
			from bouquets
			where author = florists.id
		) = 0
			then 'No bouqets'
		else (
			select count(*)
			from bouquets
			where author = florists.id
		)::text
		end bouqets
from florists
group by florists.id, florists.fullname;

-- Инструкция UPDATE со скалярным подзапросом в предложении SET
-- Заменяет customer_id на id продавца с phone = '89265289502'
update florists_customers
set customer_id = (
	select id
	from customers
	where phone = '89265289502'
)
where customer_id = 2;

-- Инструкцию SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
-- покупатели, взаимодействующие с двумя и более флористами
select customers.id, customers.fullname
from customers
	join florists_customers fc on customers.id = fc.customer_id
group by customers.id
having count(*) > 1;


-- Задание 3 (10 баллов)
-- Создать хранимую процедуру с входным параметром – имя базы данных,
-- которая выводит имена ограничений CHECK и выражения SQL, которыми
-- определяются эти ограничения CHECK, в тексте которых на языке SQL
-- встречается предикат 'LIKE'. Созданную хранимую процедуру
-- протестировать.
drop procedure if exists likes_constraints(db text);

drop extension dblink;
create extension dblink;
create procedure likes_constraints(in db text) language plpgsql as $$
declare
	record_of_constraints record;
begin
	for record_of_constraints in
		select *
		from dblink(
			concat('dbname=', db, ' options=-csearch_path='),
			'select conname, consrc
			from pg_constraint
			where contype = ''c'' and (lower(consrc) like ''% like %'' or consrc like ''% ~~ %'')'
		)
		as t1(conname varchar, consrc varchar)
	loop
		raise info 'Name: %, src: %', record_of_constraints.conname, record_of_constraints.consrc;
	end loop;
end
$$;

-- test
alter table customers
	add constraint fullname_contains_e check (fullname like '%e%');

do $$ begin
		call likes_constraints('rk2');
end; $$;
