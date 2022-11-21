/*
Инструкция SELECT, использующая предикат LIKE

Получить id, вид и название животных, у кого была найдена Адентия и другие похожие заболевания
*/
SELECT id, kind, animal_name, diagnosis.name
FROM animals JOIN diagnosis ON animals.id_diagnosis = diagnosis.id_diagnosis
WHERE diagnosis.name LIKE '%Адентия'