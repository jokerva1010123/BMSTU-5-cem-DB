-- Предикат EXISTS с вложенным подзапросом

-- Получить имена и фамилии покупателей,
-- у которых есть бонусная карта, если
-- есть покупатели, которым 18 лет.

SELECT C.first_name, C.last_name
FROM customers AS C
WHERE C.card = TRUE AND EXISTS (SELECT C.id
                                FROM customers AS C
                                WHERE C.age = 18);
