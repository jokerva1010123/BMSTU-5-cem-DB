DROP TABLE if exists veterinarian CASCADE;
DROP TABLE if exists diagnosis CASCADE;
DROP TABLE if exists treatment CASCADE;
DROP TABLE if exists animal_owner CASCADE;
DROP TABLE if exists animals;

CREATE table veterinarian(
	id_vet INT PRIMARY KEY,
	surname VARCHAR(50),
	age INT CHECK(age >= 25 AND age <= 60),
	qualification VARCHAR(20),
	cabinet INT CHECK(cabinet >= 1 AND cabinet <= 500)
);

create table treatment
(
	id_treatment INT PRIMARY KEY,
	name VARCHAR(100),
	hospitalization VARCHAR(20) CHECK (hospitalization IN('Требуется',  'Не требуется')),
	duration INT CHECK(duration >= 5 AND duration <= 30),
	cost INT CHECK(cost >= 1000 AND cost <= 10000),
	date DATE
);

create table diagnosis
(
	id_diagnosis INT PRIMARY KEY,
	name VARCHAR(100),
	date DATE,
	degree_severity VARCHAR(20) CHECK (degree_severity IN('Легкая',  'Средняя', 'Тяжелая')),
	need_operation VARCHAR(20) CHECK (need_operation IN('Требуется',  'Не требуется'))
);

create table animal_owner
(
	id_owner INT PRIMARY KEY,
	name VARCHAR(100)
);

create table animals
(
	id INT PRIMARY KEY,
	animal_name VARCHAR(50),
	kind VARCHAR(30),
	age INT CHECK(age >= 1 AND age <= 20),
	
	id_owner INT,
	FOREIGN KEY (id_owner) REFERENCES animal_owner(id_owner),
	
	id_vet INT,
	FOREIGN KEY (id_vet) REFERENCES veterinarian(id_vet),
	
	id_diagnosis INT,
	FOREIGN KEY (id_diagnosis) REFERENCES diagnosis(id_diagnosis),
	
	id_treatment INT,
	FOREIGN KEY (id_treatment) REFERENCES treatment(id_treatment)
);

COPY animal_owner (id_owner, name) FROM 'D:\BMSTU\BMSTU-5-cem-DB\lab_01\database_csv\owners.csv' DELIMITER ';' CSV;
COPY veterinarian (id_vet, surname, age, qualification, cabinet) FROM 'D:\BMSTU\BMSTU-5-cem-DB\lab_01\database_csv\veterinarians.csv' DELIMITER ';' CSV;
COPY treatment (id_treatment, name, hospitalization, duration, cost, date) FROM 'D:\BMSTU\BMSTU-5-cem-DB\lab_01\database_csv\treatments.csv' DELIMITER ';' csv;
COPY diagnosis (id_diagnosis, name, date, degree_severity, need_operation) FROM 'D:\BMSTU\BMSTU-5-cem-DB\lab_01\database_csv\diagnosises.csv' DELIMITER ';' CSV;
COPY animals (id, animal_name, kind, age, id_owner, id_vet, id_diagnosis, id_treatment) FROM 'D:\BMSTU\BMSTU-5-cem-DB\lab_01\database_csv\animals.csv' DELIMITER ';' CSV;

select * from veterinarian;
select * from animal_owner;
select * from animals;
select * from diagnosis;
select * from treatment;