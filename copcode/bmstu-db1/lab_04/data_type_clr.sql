-- Определяемый пользователем тип данных CLR.

-- Получить информацию о продаже товара девятому покупателю.

CREATE TYPE sale_type AS
(
    sort VARCHAR,
    color VARCHAR,
    name VARCHAR,
    profit INTEGER
);

CREATE OR REPLACE FUNCTION get_sale(id_customer INTEGER)
RETURNS SETOF sale_type AS
$$
	query = '''
        	SELECT wsm.sort, wsm.color, wsm.name, wsm.profit
        	FROM ((sales AS s JOIN wines AS w ON s.wine_id = w.id) AS ws
                    JOIN manufactures AS m ON ws.manufacture_id = m.id) AS wsm
        	WHERE wsm.customer_id = '%s'
        	''' % (id_customer)

	result = plpy.execute(query)
	
	if result is not None:
		return result
$$ LANGUAGE plpython3u;

SELECT *
FROM get_sale('9');
