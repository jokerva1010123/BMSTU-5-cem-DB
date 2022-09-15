-- Функция поиска информации
-- о покупателях по возрасту.

CREATE OR REPLACE FUNCTION get_customers_by_age(value_age INTEGER) 
RETURNS TABLE (id INTEGER, first_name VARCHAR, 
               last_name VARCHAR, age INTEGER, 
               card BOOLEAN, bonuses INTEGER) AS
'
BEGIN

RETURN QUERY
SELECT *
FROM customers AS c
WHERE c.age = $1;

END;
' LANGUAGE plpgsql;


SELECT *
FROM get_customers_by_age(18);
