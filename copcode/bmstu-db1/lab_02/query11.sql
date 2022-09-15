-- Создание новой временной локальной таблицы

-- Создать таблицу покупателей, у которых есть
-- бонусная карта.

SELECT C.first_name, C.last_name, C.bonuses
INTO bonuses
FROM customers AS C
WHERE C.card = TRUE;
