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
where animals.kind = 'Змея' and animals.age = get_min_age_snake()