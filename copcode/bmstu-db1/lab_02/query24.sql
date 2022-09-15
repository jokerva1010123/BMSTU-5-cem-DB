-- Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

-- Вывести имя, фамилию, возраст и
-- максимальное число баллов покупателей
-- данного возраста.

SELECT first_name, last_name, age, MAX(bonuses) OVER(PARTITION BY age) AS max_bonuses
FROM customers;