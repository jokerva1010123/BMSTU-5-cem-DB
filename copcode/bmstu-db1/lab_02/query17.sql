-- Многострочная инструкция INSERT.

-- Вставить в таблицу поставщиков из России,
-- у которых опыт равен 10 годам.

INSERT INTO manufactures (name, country, experience, 
						  price, rating)
SELECT name, country, 10, price, rating
FROM manufactures
WHERE country = 'Russia';