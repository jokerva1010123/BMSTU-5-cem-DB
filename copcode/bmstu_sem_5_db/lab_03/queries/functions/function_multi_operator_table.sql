--вывести всех врачей, которые лечили больше животных, чем врач ... (вывести информацию о врачах, количестве их животных)

drop function if exists more_animals(vet_surname varchar(20));

create or replace function more_animals(vet_surname varchar(20))
returns table(result_vet_surname varchar(20), 
			  animal_count bigint) as
$$
begin
	return query
	select vets.surname, count(*) as cnt1
	from animals join veterinarian as vets on animals.id_vet = vets.id_vet
	group by vets.surname
	having count(*) > (select count(*) as cnt2
					   from animals join veterinarian as vets on animals.id_vet = vets.id_vet
					   where vets.surname = vet_surname)
	order by vets.surname;
end;
$$
language plpgsql;

select *
from more_animals('Акулов')

select doc->>'name' as name, count(*) as cnt1
from animals_import
group by doc->>'name'
having count(*)  > 2