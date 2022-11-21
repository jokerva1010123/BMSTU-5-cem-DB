/*
Инструкция SELECT, использующая скалярные подзапросы в выражении столбцов

Вывести всех животных старше 15 лет с максимальной стоимостью лечения
*/

SELECT id, animals.kind, animal_name,
						(SELECT MAX(treatment.cost)
						 FROM treatment
						 WHERE animals.id_treatment = treatment.id_treatment) AS max_treatment_price
FROM animals
WHERE animals.age > 15