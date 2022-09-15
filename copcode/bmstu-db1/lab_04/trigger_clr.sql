-- Триггер CLR.

-- Запись о вставке в таблицу Wines.

CREATE OR REPLACE FUNCTION insert_in_wines()
RETURNS TRIGGER AS
$$
    plpy.notice("Record inserted in table Wine")
$$ LANGUAGE plpython3u;

CREATE TRIGGER insert_wines_trigger
AFTER INSERT ON wines
FOR ROW EXECUTE PROCEDURE insert_in_wines();

INSERT INTO wines (color, sugar, sort, acidity, aging, volume)
VALUES ('red', 'sweet', 'Lambrusco', 5.5, 10, 25);

--check
SELECT *
FROM wines;
