-- Процедура доступа вывода сведений об индексах 
-- указанной таблицы в указанной базе данных.

CREATE OR REPLACE PROCEDURE rk(db_name VARCHAR, table_name VARCHAR) 
AS
$$
DECLARE
	now_record RECORD;
BEGIN
    SELECT *
    FROM pg_indexes
    WHERE tablename = table_name
    INTO now_record;

    RAISE NOTICE 'INFO: tablename %, indexname %, indexdef %',
	now_record.tablename, now_record.indexname, now_record.indexdef;
END;
$$ LANGUAGE plpgsql;

CALL RK('regina', 'wines');

SELECT *
FROM pg_indexes;
