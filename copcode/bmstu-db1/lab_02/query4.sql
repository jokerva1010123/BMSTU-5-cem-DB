-- Предикат IN с вложенным подзапросом

-- Получить список доходов от покупателей с
-- бонусной картой.

SELECT S.profit
FROM sales AS S
WHERE S.customer_id IN (SELECT C.id
                        FROM customers AS C
                        WHERE C.card = TRUE);
