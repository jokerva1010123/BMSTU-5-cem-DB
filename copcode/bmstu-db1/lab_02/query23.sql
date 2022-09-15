-- Рекурсивное обобщенное табличное выражение.

-- Вывести гамму нот.

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

-- ОТВ
WITH RECURSIVE RCTE(id, next_id, note)
AS
(
	SELECT id, next_id, note
	FROM gamma
	WHERE id = 1
	UNION ALL
	SELECT G.id, G.next_id, G.note
	FROM gamma AS G
	JOIN RCTE AS R ON R.next_id = G.id
)

SELECT id, next_id, note
FROM RCTE;
