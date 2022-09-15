-- Воякин Алексей ИУ7-54Б Вариант №1

create table if not exists empl (
	id_empl serial  not null primary key,
	fio varchar(50) not null,
	birth_year int,
	post varchar(50)
);

create table if not exists oper (
	id_oper serial  not null primary key,
	id_empl int not null,
	id_kurs int not null,
	summ int not null
);

create table if not exists kurs (
	id_kurs serial  not null primary key,
	id_val int not null,
	sale int not null,
	buy int not null
);

create table if not exists val (
	id_val serial  not null primary key,
	name varchar(20) not null
);

insert into empl (id_empl, fio, birth_year, post)
values (1, 'Пупкин', 1998, 'Слесарь');
insert into empl (id_empl, fio, birth_year, post)
values (2, 'Фадеев', 1976, 'Повар');
insert into empl (id_empl, fio, birth_year, post)
values (3, 'Агафонов', 1988, 'Водитель');
insert into empl (id_empl, fio, birth_year, post)
values (4, 'Ильин', 2001, 'Учитель');
insert into empl (id_empl, fio, birth_year, post)
values (5, 'Виноградов', 1987, 'Водитель');
insert into empl (id_empl, fio, birth_year, post)
values (6, 'Молчанов', 1962, 'Тракторист');
insert into empl (id_empl, fio, birth_year, post)
values (7, 'Некрасов', 1975, 'Программист');
insert into empl (id_empl, fio, birth_year, post)
values (8, 'Кондратьев', 1977, 'Консьерж');
insert into empl (id_empl, fio, birth_year, post)
values (9, 'Третьяков', 1999, 'Дворник');
insert into empl (id_empl, fio, birth_year, post)
values (10, 'Новиков', 2000, 'Пилот');

insert into oper (id_oper, id_empl, id_kurs, summ)
values (1, 2, 1, 35);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (2, 6, 1, 47);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (3, 2, 7, 17);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (4, 9, 6, 22);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (5, 1, 8, 34);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (6, 5, 2, 95);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (7, 7, 10, 17);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (8, 10, 5, 24);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (9, 4, 5, 64);
insert into oper (id_oper, id_empl, id_kurs, summ)
values (10, 6, 3, 72);

insert into kurs (id_kurs, id_val, sale, buy)
values (1, 1, 20, 25);
insert into kurs (id_kurs, id_val, sale, buy)
values (2, 2, 34, 36);
insert into kurs (id_kurs, id_val, sale, buy)
values (3, 3, 48, 55);
insert into kurs (id_kurs, id_val, sale, buy)
values (4, 4, 27, 30);
insert into kurs (id_kurs, id_val, sale, buy)
values (5, 5, 19, 20);
insert into kurs (id_kurs, id_val, sale, buy)
values (6, 6, 24, 31);
insert into kurs (id_kurs, id_val, sale, buy)
values (7, 7, 26, 29);
insert into kurs (id_kurs, id_val, sale, buy)
values (8, 8, 24, 25);
insert into kurs (id_kurs, id_val, sale, buy)
values (9, 9, 26, 26);
insert into kurs (id_kurs, id_val, sale, buy)
values (10, 10, 82, 91);

insert into val (id_val, name)
values (1, 'Доллар');
insert into val (id_val, name)
values (2, 'Евро');
insert into val (id_val, name)
values (3, 'Йен');
insert into val (id_val, name)
values (4, 'Тугрик');
insert into val (id_val, name)
values (5, 'Песо');
insert into val (id_val, name)
values (6, 'Манат');
insert into val (id_val, name)
values (7, 'Рубль');
insert into val (id_val, name)
values (8, 'Гривна');
insert into val (id_val, name)
values (9, 'Динар');
insert into val (id_val, name)
values (10, 'Фунт');

alter table kurs add constraint fk_kurs_val foreign key (id_val) references val(id_val);
alter table oper add constraint fk_oper_empl foreign key (id_empl) references empl (id_empl);
alter table oper add constraint fk_oper_kurs foreign key (id_kurs) references kurs(id_kurs);

select * from empl;
select * from oper;
select * from kurs;
select * from val;

-- Инструкцию SELECT, использующую простое выражение CASE
-- Добавил столбец старый сотрудник или молодой.
select id_empl, fio, birth_year, 
	case
		when birth_year < 2020 and birth_year > 1980 then 'Молодой'
		when birth_year <= 1980 then 'Старый'
	end as description
from empl;

-- Инструкцию, использующую оконную функцию
-- Добавил вывод максимальной и минимальной суммы транзакции для каждого отдельного курса валют
select id_oper, id_empl, id_kurs, summ,
	max(summ) over (partition by id_kurs) as max_summ_transaction,
	min(summ) over (partition by id_kurs) as min_summ_transaction
from oper;

-- Инструкцию SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
-- Вывести стоимость продажи и покупки тех курсов валют, операции по которым совершались больше одного раза
select oper.id_kurs, kurs.sale, kurs.buy, count(*)
from oper join kurs on oper.id_kurs = kurs.id_kurs
group by oper.id_kurs, kurs.sale, kurs.buy having count(*) > 1

-- Создать хранимую процедуру без параметров, в которой для экземпляра SQL Server 
-- создаются резервные копии всех пользовательских баз данных. Имя файла резервной 
-- копии должно состоять из имени базы данных и даты создания резервной копии, разделенных 
-- символом нижнего подчеркивания. Дата создания резервной копии должна быть представлена 
-- в формате YYYYDDMM. Созданную хранимую процедуру протестировать.
CREATE EXTENSION dblink;
CREATE OR REPLACE PROCEDURE backups()
AS
$$
DECLARE
	rec RECORD;
	buf RECORD;
	new_name varchar(50);
	last_name varchar(50);
	_user TEXT := 'voyakin';
  	_password TEXT := 'pswrd';
BEGIN
	FOR rec IN SELECT datname FROM pg_database WHERE datistemplate = false LOOP
		SELECT EXTRACT(YEAR FROM now())::varchar(20) || EXTRACT(DAY FROM now()) || EXTRACT(MONTH FROM now()) INTO new_name;
		new_name = rec.datname::varchar(20) || '_' || new_name;
		last_name = rec.datname;
		RAISE NOTICE 'new_name =  %', new_name;
		RAISE NOTICE 'datname =  %', last_name;
		
		SELECT pg_terminate_backend(pg_stat_activity.pid) 
		FROM pg_stat_activity 
		WHERE pg_stat_activity.datname = last_name 
		AND pid <> pg_backend_pid() INTO buf;
		
		--CREATE DATABASE new_name WITH TEMPLATE last_name;
		--PERFORM dblink_connect('host=localhost user=' || _user || ' password=' || _password || ' dbname=' || current_database());
		PERFORM dblink_exec('host=localhost user=' || _user || ' password=' || _password || ' dbname=' || last_name   -- current db
                     , 'CREATE DATABASE ' || new_name);
		
	END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL backups();






