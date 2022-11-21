/*
Создание новой временной локальной таблицы из результирующего набора
данных инструкции SELECT

Выписать в отдельную таблицу число животных, имеющих один
и тот же возраст
*/

SELECT animals.age, COUNT(animals.kind)
INTO newtable
FROM animals
GROUP BY animals.age