-- Процедура вывода гаммы нот.

-- Создание таблицы.
DROP TABLE IF EXISTS gamma;

CREATE TABLE gamma
(
	id SERIAL PRIMARY KEY,
	next_id INT,
	note VARCHAR(3)
);

-- Заполнение таблицы значениями.
INSERT INTO gamma(next_id, note) VALUES
(5, 'do'),
(7, 'fa'),
(6, 'la'),
(2, 'mi'),
(4, 're'),
(NULL, 'si'),
(3, 'sol');


CREATE OR REPLACE PROCEDURE sing(start INTEGER) 
AS
$$
DECLARE
	next_id INTEGER;
	note VARCHAR;

BEGIN
	SELECT g.next_id, g.note
	FROM gamma AS g
	INTO next_id, note
	WHERE id = start;

	RAISE NOTICE '- % -', note;

	IF next_id IS NULL THEN
    	RAISE NOTICE 'You hit all the notes!';
	ELSE
    	CALL sing(next_id);
	END IF;
END;
$$ LANGUAGE plpgsql;

CALL sing(1);
