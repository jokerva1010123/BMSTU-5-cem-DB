/*
Лаб 4-5
Пройтись по всем болезням, по всем ветеринарам, которые их лечат
в json вычислить, сколько болезнь заразила животных базе
сколько животных болеют ей, и сколько врачей ее лечат
вывести количество ветеринаров на одно животное
	*/
	
/*
Лаб 4-5
Пройтись по всем болезням, по всем ветеринарам, которые их лечат
в json вычислить, сколько болезнь заразила животных базе
сколько животных болеют ей, и сколько врачей ее лечат
вывести количество ветеринаров на одно животное
	*/
	
--25 болезнь

drop table if exists animals_with_diseases;

create table if not exists animals_with_diseases
(
	data json
);

create temp table if not exists vets_with_diseases
(
	data json;
)

insert into animals_with_diseases
select *
from animals
where id_diagnosis = 645;

insert into vets_with_diseases
select *
from animals

insert into animals_with_diseases
select * from json_object('{id, animal_name, kind, age, id_vet, id_diagnosis, id_treatment}', '{2, "Апельсинчик", "Собака", 4, 108, 645, 56}');
("id":27,"animal_name":"Апельсинчик","kind":"Ягуар","age":4,"id_vet":108,"id_diagnosis":645,"id_treatment":44);

update animals_with_diseases
set data = data || ("id":27,"animal_name":"Апельсинчик","kind":"Ягуар","age":4,"id_vet":108,"id_diagnosis":645,"id_treatment":44)::json 

select *
from animals_with_diseases

drop table animals_with_diseases_new;
create temp table animals_with_diseases_new
(
	id int primary key,
	count_vets float
);

insert into animals_with_diseases_new
select *
from animals
where id_diagnosis = 645;

select *
from animals_with_diseases_new

insert into animals_with_diseases_new values
(2, 'Апельсинчик', 'Собака', 4, 108, 645, 56)

drop function get_count_vets_by_animals(id_diagnosis_input int);

create or replace function get_count_vets_by_animals(id_diagnosis_input int)
returns real as
$$
	for i in range(1000):
		count_animals = 0
		count_vets = 0
		count_vets_by_animals = 0

		result = plpy.execute("select * \
								from animals \
								where animals.id_diagnosis = (%s)" % (i))

		if result:
			for elem in result:
				count_animals += 1

			flag_was_vet = 0

			for elem in result:
				flag_was_vet = 0
				vet = elem["id_vet"]
				for id_vet in result:
					if id_vet["id_vet"] == vet:
						flag_was_vet += 1
						count_vets += 1

		if count_vets - 1 != 0:
			count_vets_by_animals = count_animals / (count_vets - 1)
		else:
			count_vets_by_animals = 0
		plpy.execute("insert into all_data \
					 values({}, {})".format(i, count_vets_by_animals))
	return 0;
$$
language plpython3u;



drop table all_data;
create temp table all_data
(
	id int primary key,
	count_vets float
)

create or replace function output_all()
returns integer as
$$
	count_vet = get_count_vets_by_animals(645)
	return count_vet

$$
language plpython3u;

select *
from all_data

select output_all() as count;
select get_count_vets_by_animals(1);

vet = 0
	vet = result[0]["id_vet"]
	if vet == 108:
		count_vets += 1
	return count_vets

from animals join veterinarians on animals.id_vet = veterinarians.id_vet
			 join diagnoses on animals.id_diagnosis = diagnoses.id_diagnosis
			
SELECT row_to_json(u) result FROM all_data u;


