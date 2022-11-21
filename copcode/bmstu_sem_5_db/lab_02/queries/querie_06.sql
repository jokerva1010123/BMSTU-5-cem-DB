/*
Инструкция SELECT, использующая предикат сравнения с квантором

Вывести всех собак, которые старше кошки Норман
*/

SELECT animals.id, animals.kind, animals.animal_name, animals.age
FROM animals
WHERE animals.kind = 'Собака' AND animals.age > ALL 
(SELECT animals.age						 
 FROM animals									 
 WHERE animals.kind = 'Кошка' AND animals.animal_name = 'Норман')