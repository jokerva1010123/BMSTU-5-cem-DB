/*
Инструкция SELECT, консолидирующая данные с помощью предложения
GROUP BY, и предложения HAVING

Получить количество животных, чей возраст не превышает 10 лет 
*/

SELECT animals.age, count(animals.kind)
FROM animals
GROUP BY animals.age
HAVING animals.age < 10