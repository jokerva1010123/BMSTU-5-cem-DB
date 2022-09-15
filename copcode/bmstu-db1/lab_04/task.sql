
UPDATE sales
SET price = 3526
WHERE id = 1;

--- Получить набор вин по price.

CREATE OR REPLACE FUNCTION get_wines_by_price(need_price INTEGER)
RETURNS TABLE(color VARCHAR, sugar VARCHAR, sort VARCHAR, acidity FLOAT, aging INTEGER, price INTEGER) 
AS $$
    query = '''
            SELECT ws.color, ws.sugar, ws.sort, ws.acidity, ws.aging, ws.price
            FROM (wines AS w JOIN sales AS s ON w.id = s.wine_id) AS ws
            WHERE ws.price = '%s'
            ''' % (need_price)
    
    result = plpy.execute(query)

    result_table = []

    if result is not None:
        for wine in result:
        	result_table.append(wine)
    
    return result_table

$$ LANGUAGE plpython3u;

SELECT *
FROM get_wines_by_price('3526');

