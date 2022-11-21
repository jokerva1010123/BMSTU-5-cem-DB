/*
Инструкция SELECT, использующая рекурсивное обобщенное
табличное выражение
*/
CREATE TABLE vets_test
(
	id_vet INT NOT NULL PRIMARY KEY,
	surname VARCHAR(50),
	qualification INT
);

INSERT INTO vets_test VALUES
(1, 'Иванов', 1),
(2, 'Петров', 4),
(3, 'Сидоров', 2);

WITH RECURSIVE recursivetest(id, surname, qualification) AS
(
	SELECT id_vet, surname, qualification
	FROM vets_test AS vet
	WHERE vet.id_vet = 1
	UNION ALL
	--определение рекурсивного элемента
	SELECT vet.id_vet, vet.surname, vet.qualification
	FROM veterinarian AS vet
	JOIN recursivetest rec on vet.id_vet = rec.id
)
SELECT *
FROM recursivetest;

--доделать