DROP TABLE IF EXISTS netflix;

CREATE TEMP TABLE netflix
(
	serial jsonb
);

INSERT INTO netflix(serial) VALUES
('{"id": 1, "title": "Money heist", "year": 2017, "seasons": 5, "age": "18+"}'),
('{"id": 2, "title": "Elite", "year": 2018, "seasons": 4, "age": "18+"}'),
('{"id": 3, "title": "Lucifer", "year": 2016, "seasons": 6, "age": "18+"}'),
('{"id": 4, "title": "Riverdale", "year": 2017, "seasons": 6, "age": "18+"}'),
('{"id": 5, "title": "LOVE, DEATH & ROBOTS", "year": 2019, "seasons": 2, "age": "18+"}');

--check
SELECT *
FROM netflix;