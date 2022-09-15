DROP TABLE IF EXISTS table1;

CREATE TABLE IF NOT EXISTS table1
(
	id              INTEGER,
	var1            VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm   DATE
);

INSERT INTO table1(id, var1, valid_from_dttm, valid_to_dttm) 
VALUES
(1, 'A', '2018-09-01', '2018-09-15'),
(1, 'B', '2018-09-16', '5999-12-31');


DROP TABLE IF EXISTS table2;

CREATE TABLE IF NOT EXISTS table2
(
	id              INTEGER,
	var2            VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm   DATE
);

INSERT INTO table2(id, var2, valid_from_dttm, valid_to_dttm) 
VALUES
(1, 'A', '2018-09-01', '2018-09-18'),
(1, 'B', '2018-09-19', '5999-12-31');


WITH versioned_connect
AS
(
	SELECT t1.id, t1.var1, t2.var2, greatest(t1.valid_from_dttm, t2.valid_from_dttm) AS valid_from_dttm, 
           least(t1.valid_to_dttm, t2.valid_to_dttm) AS valid_to_dttm
	FROM table1 AS t1 JOIN table2 AS t2 ON t1.id = t2.id
)

SELECT *
FROM versioned_connect
WHERE valid_from_dttm <= valid_to_dttm
ORDER BY id, valid_from_dttm;
