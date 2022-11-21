create table table1
(
	id INT NOT NULL,
	var1 VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm DATE
);

create table table2
(
	id INT NOT NULL,
	var2 VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm DATE
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-15'),
		(1, 'B', '2018-09-16', '5999-12-31');
		
INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-18'),
		(1, 'B', '2018-09-19', '5999-12-31');

SELECT t1.id, var1, var2, 
		GREATEST(t1.valid_from_dttm, t2.valid_from_dttm) as valid_from_dttm,
		LEAST(t1.valid_to_dttm, t2.valid_to_dttm) as valid_to_dttm
FROM table1 as t1, table2 as t2
WHERE t1.id = t2.id AND t1.valid_from_dttm <= t2.valid_to_dttm
		AND t2.valid_from_dttm <= t1.valid_to_dttm