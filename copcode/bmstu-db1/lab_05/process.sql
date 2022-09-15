DROP TABLE IF EXISTS netflix;

CREATE TEMP TABLE netflix
(
	serial jsonb
);

INSERT INTO netflix(serial) VALUES
('{"id": 1, "title": "Money heist", "year": 2017, "seasons": 5, "age": "18+", "author": {"name": "Alex Pina", "country": "Spain"}}'),
('{"id": 2, "title": "Elite", "year": 2018, "seasons": 4, "age": "18+", "author": {"name": "Carlos Montero", "country": "Spain"}}'),
('{"id": 3, "title": "Lucifer", "year": 2016, "seasons": 6, "age": "18+", "author": {"name": "Tom Kapinos", "country": "USA"}}'),
('{"id": 4, "title": "Riverdale", "year": 2017, "seasons": 6, "age": "18+", "author": {"name": "Roberto Aguirre-Sacasa", "country": "USA"}}'),
('{"id": 5, "title": "LOVE, DEATH & ROBOTS", "year": 2019, "seasons": 2, "age": "18+", "author": {"name": "Tim Miller", "country": "USA"}}');

-- 1. Извлечь JSON фрагмент из JSON документа

SELECT serial->'title' AS name, serial->'author' AS author
FROM netflix;

-- 2. Извлечь значения конкретных узлов JSON документа

SELECT serial->'title' AS name, serial->'author'->'name' AS author_name, serial->'author'->'country' AS country
FROM netflix;

-- 3. Выполнить проверку существования атрибута

CREATE OR REPLACE FUNCTION is_atr_exists(serial jsonb, atr VARCHAR)
RETURNS BOOL AS
$$
BEGIN
	RETURN (serial->atr) IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

SELECT serial->'title' AS name, is_atr_exists(netflix.serial, 'age') AS is_age_exists
FROM netflix;

-- 4. Изменить JSON документ

UPDATE netflix
SET serial = serial || '{"seasons": 5}'::jsonb
WHERE (serial->>'id')::int = 2;

SELECT *
FROM netflix;

-- 5. Разделить JSON документ на несколько строк по узлам

DROP TABLE IF EXISTS netflix;

CREATE TEMP TABLE netflix
(
	serial jsonb
);

INSERT INTO netflix(serial) VALUES
('[
 	{"id": 1, "title": "Money heist", "year": 2017, "seasons": 5, "age": "18+", "author": {"name": "Alex Pina", "country": "Spain"}},
	{"id": 2, "title": "Elite", "year": 2018, "seasons": 4, "age": "18+", "author": {"name": "Carlos Montero", "country": "Spain"}},
	{"id": 3, "title": "Lucifer", "year": 2016, "seasons": 6, "age": "18+", "author": {"name": "Tom Kapinos", "country": "USA"}},
	{"id": 4, "title": "Riverdale", "year": 2017, "seasons": 6, "age": "18+", "author": {"name": "Roberto Aguirre-Sacasa", "country": "USA"}},
	{"id": 5, "title": "LOVE, DEATH & ROBOTS", "year": 2019, "seasons": 2, "age": "18+", "author": {"name": "Tim Miller", "country": "USA"}}
 ]');

SELECT *
FROM netflix;

SELECT jsonb_array_elements(serial::jsonb)
FROM netflix;