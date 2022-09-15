-- insert.

-- Добавить в таблицу покупателей
-- Кирилла Ковальца, которому 19 лет,
-- с бонусной картой с 10000 баллами
-- на ней.

INSERT INTO customers (first_name, last_name, 
					   age, card, bonuses)
VALUES ('Kirill', 'Kovalets', 19, TRUE, 10000);
