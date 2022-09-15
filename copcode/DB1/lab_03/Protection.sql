-- Защита ЛР3
-- Вывести названия таблиц и их размер.

create or replace procedure show_all_tables_with_size()
as
$$
declare
	cur cursor for
		select T.table_name, C.oid
		from information_schema.tables T join pg_class C on T.table_name = relname
        where T.table_schema = 'public';
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '{table : %} {size : %}', row.table_name, pg_relation_size(row.oid);
	end loop;
	close cur;
end
$$
language 'plpgsql';

call show_all_tables_with_size();
