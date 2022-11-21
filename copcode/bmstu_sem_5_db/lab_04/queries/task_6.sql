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
from get_count_kind_new('Собака')