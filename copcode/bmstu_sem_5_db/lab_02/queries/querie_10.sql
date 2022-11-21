/*
Инструкция SELECT, использующая поисковое выражение case

Описать дороговизну лечения в зависимости от её стоимости:
дешевая/средняя/дорогая
*/

SELECT animals.id, animals.animal_name, treatment.cost, 
		CASE
		WHEN treatment.cost < 3000 THEN 'Дешевая'
		WHEN treatment.cost > 7000 THEN 'Дорогая'
		ELSE 'Средняя'
		END AS cost_level
FROM animals JOIN treatment ON animals.id_treatment = treatment.id_treatment