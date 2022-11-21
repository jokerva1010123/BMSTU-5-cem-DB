create table veterinarian
(
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
	cost INT CHECK(cost >= 1000 AND cost <= 10000)
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

create table animals
(
	id INT PRIMARY KEY,
	animal_name VARCHAR(50),
	kind VARCHAR(30),
	age INT CHECK(age >= 1 AND age <= 20),
	id_vet INT,
	FOREIGN KEY (id_vet) REFERENCES veterinarian(id_vet),
	
	id_diagnosis INT,
	FOREIGN KEY (id_diagnosis) REFERENCES diagnosis(id_diagnosis),
	
	id_treatment INT,
	FOREIGN KEY (id_treatment) REFERENCES treatment(id_treatment)
);