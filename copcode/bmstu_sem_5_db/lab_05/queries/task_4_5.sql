/*
	разделить несколько строк json документа по узлам;
*/

create temp table if not exists visit_animals(doc JSON);
insert into visit_animals values ('[{"animal_id": 0, "vet_id": 1},
  {"animal_id": 2, "vet_id": 2}, {"animal_id": 3, "vet_id": 1}]');

select * from visit_animals;

select jsonb_array_elements(doc::jsonb)
from visit_animals;