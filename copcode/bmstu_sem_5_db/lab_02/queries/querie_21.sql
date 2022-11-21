/*
Инструкция SELECT с вложенным коррелированным подзапросом
в предложении WHERE
*/
DELETE FROM animals
WHERE id IN
(
	SELECT id
	FROM animals
	WHERE age = 1
)