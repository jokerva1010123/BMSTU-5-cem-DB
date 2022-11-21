/*
  Защита:
  Выбрать какого-либо ветеринара. Найти всех животных, которых он оперировал
  со средней тяжестью диагноза и выписать вид животных и их количество;
  отсортировать по количеству (уменьшение)
*/
--INSERT INTO animals (id, animal_name, kind, age, id_vet, id_diagnosis, id_treatment)
--VALUES(1001, 'Розочка', 'Канарейка', 1, 12, 3, 47);

SELECT animals.kind, vet.surname, diagn.degree_severity, count(animals.kind)
FROM animals 
	JOIN veterinarian AS vet ON animals.id_vet = vet.id_vet
	JOIN diagnosis AS diagn ON animals.id_diagnosis = diagn.id_diagnosis
WHERE vet.surname IN (SELECT veterinarian.surname
								FROM veterinarian
								WHERE veterinarian.surname = 'Авксентьева')
	 AND diagn.degree_severity = 'Средняя'
GROUP BY animals.kind, vet.surname, diagn.degree_severity
ORDER BY count(animals.kind) DESC