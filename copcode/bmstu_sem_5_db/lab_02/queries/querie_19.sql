/*
Инструкция UPDATE со скалярным подзапросом в предложении SET
*/
UPDATE treatment
SET cost = 
(
	SELECT MIN(cost)
	FROM treatment
)
WHERE id_treatment = 2