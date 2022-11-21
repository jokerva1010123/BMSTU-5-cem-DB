--хранимая процедура доступа к метаданным
--вывести информацию об идентификаторе строки и используемой кодировки

create or replace procedure get_metadata(db_name text) as
$$
declare
	db_id int;
	db_encoding varchar;
begin
	select pg.oid, pg_encoding_to_char(pg.encoding) 
	from pg_database as pg
	where pg.datname = db_name
	
	into db_id, db_encoding;
	raise notice 'Database: %, DB_ID: %, DB_encoding: %', db_name, db_id, db_encoding;
end;
$$
language plpgsql;

call get_metadata('postgres');