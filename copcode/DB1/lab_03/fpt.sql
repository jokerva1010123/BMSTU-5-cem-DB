-- A. Четыре функции.

-- 1) Скалярная функция.
-- Функция возвращает максимальную стоимость обучения по всем учреждениям.

create or replace function max_cost() 
returns int as
$$	
begin
	return (
		select service_cost
		from contract
		order by service_cost desc
		limit 1
	);
end
$$
language 'plpgsql';

select max_cost();

-- 2) Подставляемая табличная функцию.
-- Вернуть работников по полу.

create or replace function employee_by_gender(char)
returns setof employee as
$$
begin
	return query (
		select *
		from employee E
		where E.gender = $1
	);
end
$$
language 'plpgsql';

select *
from employee_by_gender('муж')
order by full_name;

-- 3) Многооператорная табличная функция. Переделать
-- Вывод назваия группы с максимальным кол-вом детей.

create or replace function max_person_group() 
returns char as
$$
declare 
group_name text;
begin
	group_name := (
		select G.name
		from child C join groupp G on C.id_group = G.id_group
		group by G.name
		order by count(*) desc
		limit 1
	);
	return group_name;
end
$$
language 'plpgsql';

select max_person_group();

-- 4) Рекурсивная функция или функция с рекурсивным ОТВ
-- Рекурсивный вывод информации о детских садах по их id.

create or replace function rec_ins_info(int, int)
returns setof institution as
$$
begin
	if $1 < $2 then 
		return query
		(
			select *
        	from rec_ins_info($1 + 1, $2)
		);
	end if;
	return query
	(
		select *
		from institution
		where id_institution = $1
	);
end
$$
language 'plpgsql';

select * from rec_ins_info(1, 10);

-- B. Четыре хранимых процедуры

-- 1) Хранимую процедуру без параметров или с параметрами.
-- Добавить всем работникам 1 день стажа

select *
into temp employee_temp
from employee;

select * from employee_temp order by id_employee;


create or replace procedure inc_experience()
as
$$
begin
update employee_temp
set experience = experience + interval '1 day';
end
$$
language 'plpgsql';

call inc_experience();

-- 2) Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ.
-- Рекурсивно увеличить опыт работы сотрудников на необходимое кол-во дней

create or replace procedure rec_inc_experience(int, int, int)
as
$$
begin
	if $1 < $2 then 
		call rec_inc_experience($1 + 1, $2, $3);
	end if;
	update employee_temp
	set experience = experience + format('%s day', $3::text)::interval;
end
$$
language 'plpgsql';

call rec_inc_experience(1, 10, 10);

select * from employee_temp order by id_employee;

-- 3) Хранимую процедуру с курсором
-- Увеличить опыт работников у которых он меньше 2000 дней на нуобходимое кол-во дней.

create or replace procedure cur_inc_experience(days_num int)
as $$
declare
	row record;
	cur cursor for
		select * from employee_temp
		where experience < '2000 days';
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		update employee_temp
		set experience = experience + format('%s days', days_num::text)::interval
		where id_employee = row.id_employee;
	end loop;
	close cur;
end
$$ language 'plpgsql';

call cur_inc_experience(20);

select * from employee_temp order by id_employee;

-- 4) Хранимую процедуру доступа к метаданным
-- https://postgrespro.ru/docs/postgresql/12/information-schema
-- https://postgrespro.ru/docs/postgrespro/9.5/catalogs

select * from information_schema.table_constraints;

create or replace procedure show_all_PK()
as
$$
declare
	cur cursor for 
		select constraint_name, table_name, constraint_type
		from information_schema.table_constraints
		where constraint_type = 'PRIMARY KEY';
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '{constraint : %} {table : %}', row.constraint_name, row.table_name;
	end loop;
	close cur;
end
$$
language 'plpgsql';

call show_all_PK();

-- C. Два DML триггера

-- 1) Триггер AFTER
-- Создал урезанную копию таблицы parent, добавил поле int которое указывает сколько было добавлено
-- записей в таблицу после текущей. Тригер увеличивает этот атрибут у всех записей при добавлении

create temp table if not exists parent_temp
(
 	full_name varchar(50) not null,
 	gender nchar(3) not null,
	num_after_this int not null
);


create or replace function inc_num() 
returns trigger AS
$$
begin
	update parent_temp
	set num_after_this = num_after_this + 1;
	return new;
end
$$
language 'plpgsql';

create trigger trigger_after_insert
after insert on parent_temp for each row
execute function inc_num();


select * from parent_temp order by num_after_this desc;


insert into parent_temp (full_name, gender, num_after_this)
values ('1', 'муж', -1);
insert into parent_temp (full_name, gender, num_after_this)
values ('2', 'муж', -1);
insert into parent_temp (full_name, gender, num_after_this)
values ('3', 'жен', -1);
insert into parent_temp (full_name, gender, num_after_this)
values ('4', 'муж', -1);
insert into parent_temp (full_name, gender, num_after_this)
values ('5', 'жен', -1);

-- 2) Триггер INSTEAD OF
-- Вместо обновления в таблице вывести сообщение "permission denied"

create view group_view as
select *
from groupp;

create or replace function cancel_update() 
returns trigger as
$$
begin
	raise notice 'permission denied';
	return new;
end
$$ language 'plpgsql';


create trigger cancel_update_trigger
instead of update on group_view for each row 
execute function cancel_update();

select *
from group_view;

update group_view
set type = 'Средняя'
where id_group = 1;


-- написать триггер after который переформатирует.
