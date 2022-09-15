-- Group by with having.

-- Посчитать число покупателей
-- каждого возраста.

SELECT age, COUNT(age)
FROM customers
GROUP BY age
HAVING age > 20;
