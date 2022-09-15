-- Использование поискового выражения CASE

-- Разделить поставщиков на не популярных,
-- средних по популярности, популярных и
-- очень популярных по рейтингу.

SELECT M.name,
       CASE
            WHEN M.rating <  2   THEN 'not popular'
            WHEN M.rating <  5   THEN 'average'
            WHEN M.rating <  8 THEN 'popular'
            ELSE 'very popular'
       END AS demand
FROM manufactures AS M;
