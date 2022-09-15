-- Обновить страну поставщика с id = 1000 на Италию

CREATE OR REPLACE FUNCTION update_country(m_id INTEGER, new_country VARCHAR) 
RETURNS TABLE (id INTEGER, name VARCHAR, 
               country VARCHAR, experience INTEGER, 
               price INTEGER, rating INTEGER) AS
'
BEGIN

UPDATE manufactures AS m
SET country = $2
WHERE m.id = $1;

RETURN QUERY
SELECT *
FROM manufactures;

END;
' LANGUAGE plpgsql;


SELECT *
FROM update_country(1000, 'Italia');