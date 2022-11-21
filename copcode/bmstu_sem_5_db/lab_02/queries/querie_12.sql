/*
Интсрукция SELECT, использующая вложенные коррелированные 
подзапросы в качестве производных таблиц в предложении 
FROM

Выборка животных, чье лечение стоит больше 9000
*/

SELECT animals.kind, animals.animal_name, H.cost
FROM animals JOIN (SELECT treatment.id_treatment, treatment.cost
				   FROM treatment
				   WHERE treatment.cost > 9000) AS H ON animals.id_treatment = H.id_treatment
