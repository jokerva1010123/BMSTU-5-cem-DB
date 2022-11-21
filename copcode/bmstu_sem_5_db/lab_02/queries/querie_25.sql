DROP TABLE IF EXISTS dupl_test;
CREATE TABLE dupl_test
(
	id INTEGER,
	name VARCHAR,
	location VARCHAR
);

INSERT INTO dupl_test(id, name, location) VALUES
(0, 'Арчи', 'дом1'),
(1, 'Буч', 'улица'),
(2, 'Арчи', 'дом'),
(3, 'Патрик', 'улица')

DELETE FROM dupl_test *
WHERE id IN
	(SELECT id
	 FROM
		(SELECT id, ROW_NUMBER() OVER w rown
		 FROM dupl_test
		 WINDOW w AS (PARTITION BY name, location
		 ORDER BY name, location)) t
		 WHERE t.rown > 1);