--1.скаларная функция
--вывести информацию о животных, у которых имеет указанный вид с самым младшим возрастом
create or replace function min_age(kind_animal VARCHAR(30)) returns integer as
$$
begin
	return(select min(animals.age) as min_age
		   from animals
		   where animals.kind = kind_animal);
end;
$$
language plpgsql;
	
select *
from animals
where animals.kind = 'Змея' and animals.age = min_age('Змея')

--2.подставляемая табличная функция
--найти всех животных, которые лечатся у врача ...
create or replace function visit_vet(vet_surname_visit varchar(20))
returns table(animals_id int) 
as			  
$$
begin
	return query 
	(
		select animals.id
		from animals join veterinarian on animals.id_vet = veterinarian.id_vet
					 join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis
		where veterinarian.surname = vet_surname_visit
	);
end;
$$
language plpgsql;

select * from visit_vet('Авксентьева')

--3.многооператорная табличная функция
--вывести всех врачей, которые лечили больше животных, чем врач ... (вывести информацию о врачах, количестве их животных)
create or replace function more_animals(vet_surname varchar(20))
returns table(result_vet_surname varchar(20), animal_count bigint) 
as
$$
begin
	return query
	(
		select vets.surname, count(*) as cnt1
		from animals join veterinarian as vets on animals.id_vet = vets.id_vet
		group by vets.surname
		having count(*) > (select count(*) as cnt2
						   from animals join veterinarian as vets on animals.id_vet = vets.id_vet
						   where vets.surname = vet_surname)
		order by vets.surname
	);
end;
$$
language plpgsql;

select * from more_animals('Акулов')

--4.функция с рекурсивным ОТВ
--вывести приоритет вет. персонала (по подчинению)
drop table if exists vets_submission;

create temp table if not exists vets_submission
(
	id_vet int primary key,
	boss_id_vet int references vets_submission(id_vet),
	surname varchar(20)
);

insert into vets_submission(id_vet, boss_id_vet, surname)
values
(0, null, 'Абрамова'),
(1, 0, 'Абакумов'),
(2, 3, 'Аверкова'),
(3, 0, 'Аврамов'),
(4, 2, 'Абрикосов'),
(5, 4, 'Абросимова'),
(6, 1, 'Авдеева');


create or replace function recursion()
returns table(id_vet int, boss_id_vet int,
			  vet_surname varchar(30),
			  level int) 
as
$$
begin
	return query
	with recursive vs_rec(id_vet, boss_id_vet, vet_surname, level) as 
	(
		select vets_s.id_vet, vets_s.boss_id_vet, vets_s.surname, 0
		from vets_submission as vets_s
		where vets_s.boss_id_vet is null
		
		union all
		select vets_submission.id_vet, vets_submission.boss_id_vet, vets_submission.surname, vs_rec.level + 1
		from vs_rec join vets_submission on vs_rec.id_vet = vets_submission.boss_id_vet
	)
	select * from vs_rec;
end;
$$
language plpgsql;

select * from recursion()

--5.хранимая процедура с параметрами или без
--выполнить изменение в должности врачей
create or replace procedure update_vet_post(vet_surname varchar(30)) as
$$
begin
	update veterinarian
	set qualification = (select case when qualification = 'Без категории' then 'Вторая'
									 when qualification = 'Вторая' then 'Первая'
									 when qualification = 'Первая' then 'Высшая'
								end) 
	where veterinarian.surname = vet_surname;						 
end;
$$
language plpgsql;

call update_vet_post('Абакумов');

--6.хранимая процедура с рекурсивным ОТВ
--вывести приоритет вет. персонала (по подчинению)
drop procedure if exists define_submission();
drop table if exists vets_submission;

create temp table if not exists vets_submission
(
	id_vet int primary key,
	boss_id_vet int references vets_submission(id_vet),
	surname varchar(20)
);

insert into vets_submission(id_vet, boss_id_vet, surname)
values
(0, null, 'Абрамова'),
(1, 0, 'Абакумов'),
(2, 3, 'Аверкова'),
(3, 0, 'Аврамов'),
(4, 2, 'Абрикосов'),
(5, 4, 'Абросимова'),
(6, 1, 'Авдеева');

create temp table if not exists vets_submission_result
(
	surname varchar(20),
	level int
);

create or replace procedure define_submission() as
$$
begin
	with recursive vs_rec(id_vet, boss_id_vet, surname, level) as 
	(
		select vets_s.id_vet, vets_s.boss_id_vet, vets_s.surname, 0
		from vets_submission as vets_s
		where vets_s.boss_id_vet is null
		
		union all
		select vets_submission.id_vet, vets_submission.boss_id_vet, vets_submission.surname, vs_rec.level + 1
		from vs_rec join vets_submission on vs_rec.id_vet = vets_submission.boss_id_vet
	)
	insert into vets_submission_result(surname, level)
	select surname, level
	from vs_rec;
end;
$$
language plpgsql;

call define_submission();
select * from vets_submission_result;

--7.хранимая процедура с курсором
--изменить возраст животных с id
create or replace procedure changeAge(animal_id integer, newAge integer) as
$$
declare
	list record;
	kind_cursor cursor for
		select *
		from animals
		where id = animal_id;
begin
	open kind_cursor;
	loop
		fetch kind_cursor into list;
		exit when not found;
		update animals 
		set age = newAge
		where animals.id = list.id;
	end loop;
	close kind_cursor;
end;
$$
language plpgsql;

call changeAge(1, 6);

--8.хранимая процедура доступа к метаданным
--вывести информацию об идентификаторе строки и используемой кодировки
create or replace procedure get_metadata(db_name text) as
$$
declare
	db_id int;
	db_encoding varchar;
begin
	select pg.oid, pg_encoding_to_char(pg.encoding) 
	from pg_database as pg
	where pg.datname = db_name
	
	into db_id, db_encoding;
	raise notice 'Database: %, DB_ID: %, DB_encoding: %', db_name, db_id, db_encoding;
end;
$$
language plpgsql;

call get_metadata('postgres');

--9.DML триггер AFTER
--вывести информацию при обновлении ...
create or replace function update_vet_qualification()
returns trigger as
$$
begin 
	raise notice 'Old: %', old.age;
	raise notice 'New: %', new.age;
	return new;
end
$$
language plpgsql;

create or replace trigger update_vet_qualification
after update on veterinarian 
for each row
execute procedure update_vet_qualification();
	
update veterinarian
set age = 30
where id_vet < 3;

select * from veterinarian
order by id_vet ;

--10.DML триггер INSTEAD OF
--сотрудник с фамилией ... уволился из данной больницы
drop view if exists vet_view;
create view vet_view
as select * from veterinarian
where id_vet < 10;

create or replace function delete_vet()
returns trigger as
$$
begin
	raise notice 'ID: %.', old.id_vet;
	
	update vet_view 
	set cabinet = 0
	where id_vet  = old.id_vet;
	
	return new;
end;
$$
language plpgsql;

create or replace trigger delete_vet
instead of delete on vet_view  
for each row
execute procedure delete_vet();

delete from vet_view
where id_vet = 1;

select * from vet_view
order by id_vet;

--защита
create or replace function find_diagnosis(id_find_treatment integer)
returns table(id_diagnosis int) 
as 
$$
begin 
	return query
	(
		select animals.id_diagnosis 
		from animals join treatment on animals.id_treatment = treatment.id_treatment
					 join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis 
		where treatment.id_treatment = id_find_treatment
	);
end;
$$
language plpgsql;

select * from find_diagnosis(4)
