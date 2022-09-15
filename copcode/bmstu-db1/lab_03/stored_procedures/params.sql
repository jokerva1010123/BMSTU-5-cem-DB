-- Хранимая процедура обновления объема для определенного сорта вина.

CREATE OR REPLACE PROCEDURE update_volume(name_sort VARCHAR, new_volume REAL)
AS
$$
BEGIN

UPDATE wines 
SET volume = $2
WHERE sort = $1;

END;
$$ LANGUAGE plpgsql;

CALL update_volume('Lambrusco', 0.75);

SELECT sort, color, volume
FROM wines
WHERE sort = 'Lambrusco';
