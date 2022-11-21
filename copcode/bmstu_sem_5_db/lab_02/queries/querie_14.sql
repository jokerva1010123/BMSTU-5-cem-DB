/*
Инструкция SELECT, консолидирующая данные с помощью предложения
GROUP BY, но без предложения HAVING

Вывести максимальный возраст каждого из вида животных
*/

SELECT animals.kind, MAX(age)
FROM animals
GROUP BY animals.kind
