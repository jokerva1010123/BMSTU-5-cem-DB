/*
Инструкция SELECT, использующая простое выражение case

Вывести информацию о животном с дополнительным столбцом, в котором
описан возраст (молодой/взрослый/пожилой)
*/

SELECT id, kind, animal_name,
			CASE age
			WHEN (SELECT MAX(age) 
				  FROM animals) THEN 'Пожилой'
			WHEN (SELECT MIN(age)
				  FROM animals)	THEN 'Молодой'
			ELSE 'Взрослый'
			END AS comment
FROM animals
ORDER BY age