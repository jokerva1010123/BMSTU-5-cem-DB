-- Создание новой временной локальной таблицы

-- Получить информацию о цвете, сорте, сахаре
-- и цене вин, прибыль от продажи которых больше 500.

SELECT W.color, W.sort, W.sugar, WS.price
FROM wines AS W JOIN (SELECT S.wine_id, S.price
                      FROM sales AS S
                      WHERE S.profit > 500) AS WS ON W.id = WS.wine_id;
