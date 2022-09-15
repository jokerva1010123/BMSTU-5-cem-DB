-- Загрузить данные из JSON файла в таблицу.

DROP TABLE IF EXISTS double_wines;

CREATE TEMP TABLE double_wines
(
	id      SERIAL       PRIMARY KEY,
	color   VARCHAR(40)  NOT NULL,
	sugar   VARCHAR(40)  NOT NULL,
	sort    VARCHAR(40)  NOT NULL,
	acidity FLOAT        NOT NULL,
	aging   INTEGER      NOT NULL,
	volume  FLOAT        NOT NULL
);

DROP TABLE IF EXISTS json_table;

CREATE TEMP TABLE json_table
(
	data jsonb
);

COPY json_table FROM '/home/regina/bmstu/sem5/bmstu-db/sem5/lab_05/wines.json';

INSERT INTO double_wines(id, color, sugar, sort, acidity, aging, volume)
SELECT (data->>'id')::int, data->'color', data->'sugar', data->'sort', (data->>'acidity')::float, (data->>'aging')::int, (data->>'volume')::float
FROM json_table;

--check
SELECT *
FROM double_wines;