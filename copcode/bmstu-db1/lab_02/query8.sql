-- Использование скалярных подзапросов

-- Получить информацию о сорте,
-- содержании сахара и цене вина
-- красного цвета.

SELECT W.sort, W.sugar,
       (SELECT S.price
        FROM sales AS S
        WHERE S.wine_id = W.id)
FROM wines AS W
WHERE W.color = 'red';
