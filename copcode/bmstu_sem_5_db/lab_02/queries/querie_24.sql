/*
Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

Сравнить цену стоимости с минимальной ценой из этой длительности лечения
*/
SELECT id_treatment, name, duration, cost, MIN(cost) OVER (PARTITION BY duration) AS sum
FROM treatment
ORDER BY id_treatment;

WITH new_table (id_treatment, name, duration, cost, sum)
AS
(
	SELECT id_treatment, name, duration, cost, MIN(cost) OVER (PARTITION BY duration) AS sum
	FROM treatment
	ORDER BY id_treatment
)
SELECT * FROM new_table