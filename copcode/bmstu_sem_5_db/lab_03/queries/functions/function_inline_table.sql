--найти всех животных, которые лечатся у врача ... с датой поступления после 2015 года
create or replace function visit_vet_after_year(vet_surname_visit varchar(20), date_after date)
returns table(animals_id int, 
			  animal_name varchar(20), 
			  animal_kind varchar(20), 
			  animals_id_vet int, 
			  id_vet int, 
			  vet_surname varchar(20), 
			  diagnosis_date date) as
$$
begin
	return query select animals.id, animals.animal_name, animals.kind, animals.id_vet as id_vet_animal, veterinarian.id_vet,
					veterinarian.surname, diagnosis.date
					from animals join veterinarian on animals.id_vet = veterinarian.id_vet
								 join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis
					where veterinarian.surname = vet_surname_visit and diagnosis.date >= date_after;
end;					
$$
language plpgsql;

select *
from visit_vet_after_year('Авксентьева', '2016-01-01')