-- Определяемая пользователем скалярная функция CLR.

-- Узнать цену вина по id.

CREATE OR REPLACE FUNCTION get_price(id_wine INTEGER)
RETURNS INTEGER AS
$$
	query = '''
        	SELECT price
        	FROM sales
        	WHERE wine_id = '%s'
        	''' % (id_wine)

	result = plpy.execute(query)
	
	if result is not None:
		return result[0]['price']

$$ LANGUAGE plpython3u;

SELECT *
FROM get_price('9');

-- check
SELECT id, wine_id, price
FROM sales
WHERE wine_id = '9';