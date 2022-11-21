/*
Инструкция SELECT, использующая предикат сравнения
Получить всех собак в возрасте от 5 до 15 лет
*/
SELECT DISTINCT animals.id, animals.kind, animals.age  
FROM animals
WHERE animals.age >= 5 AND animals.age <= 15 and animals.kind = 'Собака'