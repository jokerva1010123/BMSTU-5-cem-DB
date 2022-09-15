-- Простое обобщенное табличное выражение.

-- Вывести информацию о покупателях, которым 19 лет.

WITH CTE
AS (SELECT *
    FROM customers
    WHERE age = 19)
SELECT *
FROM CTE;