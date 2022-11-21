/*
Инструкция SELECT, использующая агрегатные функции в выражении столбцов

Вычислить общее число енотов
*/

SELECT COUNT(animals.kind)
FROM animals
WHERE animals.kind = 'Енот'