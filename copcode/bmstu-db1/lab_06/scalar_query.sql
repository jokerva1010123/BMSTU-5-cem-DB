-- Получить число игроков без карты

SELECT COUNT(id) AS "Без карты"
FROM customers
WHERE card = False;