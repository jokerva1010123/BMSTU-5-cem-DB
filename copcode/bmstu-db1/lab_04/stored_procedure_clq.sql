-- Хранимая процедура CLR.

-- Обновить объем для сорта Lambrusco.

CREATE OR REPLACE PROCEDURE update_volume_by_sort(name_sort VARCHAR, new_volume REAL)
AS
$$
	query = '''
        	UPDATE wines
        	SET VOLUME = '%s'
        	WHERE sort = '%s'
        	''' % (new_volume, name_sort)

	result = plpy.execute(query)

$$ LANGUAGE plpython3u;

CALL update_volume_by_sort('Lambrusco', 9);

--check
SELECT *
FROM wines
WHERE sort = 'Lambrusco';