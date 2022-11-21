/*
	Создать, развернуть определяемую пользователем табличную функцию CLR.
	Вывести всех врачей, которые лечили больше животных, чем врач ... (вывести информацию о врачах, количестве их животных)
*/

create or replace function find_more_animals(vet_surname varchar(20))
returns table(result_vet_surname varchar(20), 
			  animal_count bigint) as
$$
	query = f"select vets.surname, count(*) as cnt1 \
			  from animals join veterinarians as vets on animals.id_vet = vets.id_vet \
			  group by vets.surname \
			  having count(*) > (select count(*) as cnt2 \
					   from animals join veterinarians as vets on animals.id_vet = vets.id_vet \
					   where vets.surname = '{vet_surname}') \
			  order by vets.surname;"
	result = plpy.execute(query)
	for elem in result:
		yield(elem["surname"], elem["cnt1"])
$$
language plpython3u;

select *
from find_more_animals('Акулов')