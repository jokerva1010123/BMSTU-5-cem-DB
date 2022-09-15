-- Использование простого выражение CASE

-- Получить информацию о сорте,
-- содержании сахара и цвете вина,
-- причем цвет должен быть на русском.

SELECT W.sort, W.sugar,
       CASE W.color
            WHEN 'red'   THEN 'красный'
            WHEN 'white' THEN 'белый'
            WHEN 'pink'  THEN 'розовый'
            ELSE 'неверный цвет'
       END AS цвет
FROM wines AS W;
