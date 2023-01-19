/*
	Создать, развернуть определяемую пользователем скалярную функцию CLR
	
	Вывести информацию о змеях с самым младшим возрастом
*/

create or replace function get_min_age_snake()
returns integer as
$$
	res = plpy.execute(f"select min(animals.age) as min_age\
		   from animals\
		   where animals.kind = 'Змея'");
	if res:
		return res[0]['min_age']
$$
language plpython3u;

select *
from animals
where animals.kind = 'Змея' and animals.age = get_min_age_snake();

/*
	Создать, развернуть пользовательскую агрегатную функцию CLR
	Вывести общее число какого-либо животного из списка
*/

create or replace function get_count_animals(input_animal_kind varchar)
returns integer as
$$
	count = 0
	result = plpy.execute("select * from animals");
	if result:
		for elem in result:
			if elem["kind"] == input_animal_kind:
				count += 1
	return count
$$
language plpython3u;

select get_count_animals('Собака') as cnt
from animals
group by cnt;

/*
	Создать, развернуть определяемую пользователем табличную функцию CLR.
	Вывести всех врачей, которые лечили больше животных, чем врач ... (вывести информацию о врачах, количестве их животных)
*/

create or replace function find_more_animals(vet_surname varchar(20))
returns table(result_vet_surname varchar(20), 
			  animal_count bigint) as
$$
	query = f"select vets.surname, count(*) as cnt1 \
			  from animals join veterinarian as vets on animals.id_vet = vets.id_vet \
			  group by vets.surname \
			  having count(*) > (select count(*) as cnt2 \
					   from animals join veterinarian as vets on animals.id_vet = vets.id_vet \
					   where vets.surname = '{vet_surname}') \
			  order by vets.surname;"
	result = plpy.execute(query)
	for elem in result:
		yield(elem["surname"], elem["cnt1"])
$$
language plpython3u;

select *
from find_more_animals('Акулов');

/*
	Создать, развернуть хранимую процедуру CLR
	Выполнить повышение в должности ветеринара.
*/

create or replace procedure update_vet_post_new(vet_surname varchar(30)) as
$$
	plan = plpy.prepare("update veterinarian \
						set qualification = (select case when qualification = 'Без категории' then 'Вторая' \
											 			when qualification = 'Вторая' then 'Первая' \
											 			when qualification = 'Первая' then 'Высшая' end) \
											 where veterinarian.surname = $1;",
						["varchar"])
	plpy.execute(plan, [vet_surname])
$$
language plpython3u;

call update_vet_post_new('Абрикосов');

/*
	Создать, развернуть триггер CLR
	Удалить сотрудника с фамилией ...
*/

drop trigger if exists delete_vet_new on vets_user;

drop function if exists delete_vet_new();

create or replace view vets_user as
select *
from veterinarian
where id_vet < 100;

create or replace function delete_vet_new()
returns trigger as
$$
	old_surname = TD["old"]["surname"]
	plpy.notice(f"Уволен сотрудник {old_surname}")
	
	plpy.execute(f"update vets_user \
				   set cabinet = 0 \
				   where surname = '{old_surname}';")
				   
	return TD["new"]
$$
language plpython3u;

create trigger delete_vet_new
instead of delete on vets_user
for each row
execute procedure delete_vet_new();

delete
from vets_user as vet
where vet.surname = 'Абрамова';

select *
from veterinarian;

/*
	Создать, развернуть определяемую пользователем тип данных CLR
	Выписать количество собак.
*/

create type count_kind as
(
	kind varchar,
	count int
);

create or replace function get_count_kind_new(input_kind varchar)
returns count_kind as
$$
	plan = plpy.prepare("select kind, count(kind) \
						 from animals \
						 where kind = $1 \
						 group by kind;", 
					   	 ["varchar"])
	result = plpy.execute(plan, [input_kind])
	
	if result.nrows():
		return (result[0]["kind"], result[0]["count"])
	
$$
language plpython3u;

select *
from get_count_kind_new('Собака');
