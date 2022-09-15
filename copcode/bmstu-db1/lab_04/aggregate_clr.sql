-- Пользовательская агрегатная функция CLR.

-- Узнать суммарный объем вина необходимого сорта.

CREATE OR REPLACE FUNCTION get_sum_volume(need_sort VARCHAR)
RETURNS FLOAT AS
$$
    query = '''
            SELECT SUM(volume) AS "sum_volume"
            FROM wines
            WHERE sort = '%s'
            ''' % (need_sort)
    
    result = plpy.execute(query)

    return result[0]['sum_volume']

$$ LANGUAGE plpython3u;

SELECT sort, get_sum_volume(sort) AS "sum_volume"
FROM wines
GROUP BY sort;
