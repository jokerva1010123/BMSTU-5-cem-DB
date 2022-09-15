-- Определяемая пользователем табличная функция CLR.

-- Получить информацию о покупателях розового вина.

CREATE OR REPLACE FUNCTION get_customers_by_color(need_color VARCHAR)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, age INTEGER)
AS $$
    query = '''
            SELECT wcs.first_name, wcs.last_name, wcs.age
            FROM ((customers AS c JOIN sales AS s ON c.id = s.customer_id) AS cs
                    JOIN wines AS w ON cs.wine_id = w.id) AS wcs
            WHERE wcs.color = '%s'
            ''' % (need_color)
    
    result = plpy.execute(query)

    result_table = []

    if result is not None:
        for customer in result:
        	result_table.append(customer)
    
    return result_table

$$ LANGUAGE plpython3u;

--check
SELECT *
FROM get_customers_by_color('pink');
