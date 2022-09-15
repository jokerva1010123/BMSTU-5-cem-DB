-- Вложенные подзапросы с уровнем вложенности 3

-- Получить информацию о всех поставщиках,
-- которые поставляют вина выдержкой 3 года
-- и не сорта Blush.

SELECT *
FROM manufactures
WHERE id IN (SELECT manufacture_id
             FROM sales
             WHERE wine_id IN (SELECT id
                               FROM wines
                               WHERE color IN (SELECT color
											   FROM wines
											   WHERE aging = 3 AND sort <> 'Blush'))); 
