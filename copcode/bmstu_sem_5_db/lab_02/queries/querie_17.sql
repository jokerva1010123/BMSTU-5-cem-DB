/*
Многострочная инструкция INSERT, выполняющая вставку в таблицу
результирующего набора данных вложенного подзапроса.
*/

INSERT INTO animals(id, id_diagnosis)
SELECT id * 1000 AS ID, id_diagnosis AS DiagnosisID
FROM animals
WHERE animals.kind = 'Енот' AND id > 200 AND id < 550