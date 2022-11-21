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
group by cnt