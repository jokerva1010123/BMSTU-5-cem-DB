-- Процедура с курсовом, определяющая лидеров среди поставщиков.

CREATE OR REPLACE PROCEDURE get_leaders(top INTEGER, bottom INTEGER)
AS
$$
DECLARE
    curs CURSOR FOR SELECT * 
                    FROM manufactures;

    cur_mnfctr RECORD; 

BEGIN
    RAISE NOTICE 'List of leaders:';
    OPEN curs;
    LOOP 
        FETCH curs INTO cur_mnfctr;
		EXIT WHEN NOT FOUND;

        IF cur_mnfctr.rating BETWEEN $1 AND $2 THEN
            RAISE NOTICE '%', cur_mnfctr.name;
        END IF;

    END LOOP;
    CLOSE curs;
END;
$$ LANGUAGE plpgsql;

CALL get_leaders(8, 10);

SELECT *
FROM manufactures
WHERE RATING BETWEEN 8 AND 10;
