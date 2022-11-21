/*
Инструкция SELECT, использующая обобщенное табличное выражение
*/
WITH one (kind, animal_name) AS
(
	SELECT animals.kind, animals.animal_name
	FROM animals
)
SELECT * FROM one
