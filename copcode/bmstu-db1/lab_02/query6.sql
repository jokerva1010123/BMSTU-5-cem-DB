-- Предикат сравнения с квантором

-- Получить имена и фамилии покупателей,
-- у которых число бонусов больше, чем 
-- у каждого, кому меньше 20.

SELECT C.first_name, C.last_name
FROM customers AS C
WHERE C.bonuses > ALL(SELECT C.bonuses
                      FROM customers AS C
                      WHERE C.age < 20);
