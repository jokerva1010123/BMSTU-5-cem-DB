--вывести информацию о змеях с самым младшим возрастом
create or replace function min_snake_age() returns integer as
$$
begin
	return(select min(animals.age) as min_age
		   from animals
		   where animals.kind = 'Змея');
end;
$$
language plpgsql;
	
select *
from animals
where animals.kind = 'Змея' and animals.age = min_snake_age()