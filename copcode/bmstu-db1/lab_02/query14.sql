-- Group by.

-- Получить все возможные пары
-- сорт, содержании сахара.

SELECT sort, sugar
FROM wines
GROUP BY sugar, sort;
