/*
Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом

Существуют ли те животные, у которых обнаружили раны на приеме
*/

SELECT animals.id, animals.animal_name, animals.kind, diagnosis.name
FROM animals JOIN diagnosis ON animals.id_diagnosis = diagnosis.id_diagnosis
WHERE EXISTS (SELECT animals.animal_name
			  FROM animals
			  WHERE diagnosis.name = 'Раны')
			  