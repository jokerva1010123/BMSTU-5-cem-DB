/*
Инструкция SELECT, использующая предикат IN с вложенным подзапросом

Получить id, вид и кличку животного, кого лечил врач с фамилией Кириков
*/
SELECT animals.id, animals.animal_name, animals.kind, veterinarian.surname
FROM animals JOIN veterinarian ON animals.id_vet = veterinarian.id_vet
WHERE veterinarian.surname IN (SELECT veterinarian.surname
								FROM veterinarian
								WHERE veterinarian.surname = 'Кириков')