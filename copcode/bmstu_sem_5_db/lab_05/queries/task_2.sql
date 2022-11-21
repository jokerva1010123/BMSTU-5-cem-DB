/*
	Выполнить загрузку и сохранение json файла в таблицу.
*/

create table if not exists animals_copy
(
	id INT PRIMARY KEY,
	animal_name VARCHAR(50),
	kind VARCHAR(30),
	age INT CHECK(age >= 1 AND age <= 20),
	id_vet INT,
	FOREIGN KEY (id_vet) REFERENCES veterinarians(id_vet),
	
	id_diagnosis INT,
	FOREIGN KEY (id_diagnosis) REFERENCES diagnoses(id_diagnosis),
	
	id_treatment INT,
	FOREIGN KEY (id_treatment) REFERENCES treatments(id_treatment)
);

create table if not exists animals_import(doc json);
copy animals_import from 'C:\data_lab_05\animals.json';

select * from animals_import, json_populate_record(null::animals_copy, doc);
select * from animals_import, json_populate_record(cast(null as animals_copy), doc);

insert into animals_copy
select id, animal_name, kind, age, id_vet, id_diagnosis, id_treatment
from animals_import, json_populate_record(null::animals_copy, doc);

select * from animals_copy;