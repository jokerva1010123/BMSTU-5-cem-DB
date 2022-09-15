-- Удалить дублирующих строк таблице поставщиков

WITH temp
AS
(
	SELECT *
	FROM manufactures
	UNION ALL
	SELECT *
	FROM manufactures
),
delete_twin
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY id) AS i
	FROM temp
)

SELECT *
FROM delete_twin
WHERE i = 1
