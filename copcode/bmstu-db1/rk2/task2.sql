
-- Создать хранимую процедуру с входным параметром
-- "имя таблицы", которая удаляет дубликаты записей
-- из указанной таблицы в текущей базе данных.
DROP TABLE example;

CREATE TABLE IF NOT EXISTS example
(
	id INTEGER,
	field VARCHAR(100)
);

INSERT INTO example(id, field) VALUES
('1', 'a'),
('2', 'b'),
('3', 'c'),
('1', 'a');

CREATE OR REPLACE PROCEDURE remove_duplicates(table_name VARCHAR)
AS '
BEGIN
	EXECUTE ''
		CREATE TABLE temp_table AS SELECT DISTINCT *
		FROM '' || table_name;
	EXECUTE ''
		DROP TABLE '' || table_name;
	EXECUTE ''
	ALTER TABLE temp_table RENAME TO '' || table_name;
END;
'LANGUAGE plpgsql;

CALL remove_duplicates('example');

SELECT *
FROM example;