-- Вставить покупателя в double_customers

INSERT INTO double_customers(first_name, last_name, age, card, bonuses)
VALUES ('Marina', 'Maslova', '20',  True, 1000);

SELECT *
FROM double_customers;