-- Создать хранимую процедуру с входным параметром – имя таблицы,
-- которая выводит сведения об индексах указанной таблицы в текущей базе
-- данных. Созданную хранимую процедуру протестировать.

create or replace procedure get_index_info(nametable VARCHAR)
AS
$$
declare 
    rec record;
    cur cursor for
        select * from pg_indexes pid 
        where pid.indexname = nametable and pid.schemaname = 'public'
        order by pid.indexname;
begin
    open cur;
    fetch cur into rec;
    raise notice 'TABLE: %, INDEX: %, DEFINATION: %', nametable, rec.indexname, rec.indexdef;
    close cur;
end
$$
language plpgsql;

call get_index_info('animals');

-- Создать хранимую процедуру с двумя входными параметрами – имя базы данных 
-- и имя таблицы, которая выводит сведения об индексах указанной таблицы в 
-- указанной базе данных. Созданную хранимую процедуру протестировать.

create or replace procedure get_index_info(db_name VARCHAR, table_name VARCHAR)
AS
$$
declare
    rec record;
BEGIN
    for rec in select * 
                from pg_index join pg_class on pg_index.indrelid = pg_class.oid
                where relname = table_name
    loop
        raise notice 'Element: %', rec;
    end loop;
END
$$
language plpgsql;

call get_index_info('rk2', 'table');

-- Создать хранимую процедуру без параметров, в которой для экземпляра SQL Server 
-- создаются резервные копии всех пользовательских баз данных. Имя файла резервной 
-- копии должно состоять из имени базы данных и даты создания резервной копии, разделенных 
-- символом нижнего подчеркивания. Дата создания резервной копии должна быть представлена 
-- в формате YYYYDDMM. Созданную хранимую процедуру протестировать

create or replace procedure copy_and_date()
AS
$$
declare
    rec record;
    buf record;
    new_name varchar;
    last_name varchar;
    user text := 'postgres';
    _password text := '0612';
begin
    for rec in select datname 
                from pg_database
                where datistemplate = false
    loop
        SELECT EXTRACT(YEAR FROM now())::varchar(20) || EXTRACT(DAY FROM now()) || EXTRACT(MONTH FROM now()) INTO new_name;
        new_name = rec.datname || '_' || new_name;
        last_name = rec.datname;
        select pg_terminate_backend(pg_stat_activity.pid)
        from pg_stat_activity
        where pg_stat_activity.datname = last_name
        and pid <> pg_backend_pid() into buf;
        PERFORM dblink_exec('host=localhost user=' || user || ' password=' || _password || ' dbname=' || last_name   -- current db
                     , 'CREATE DATABASE ' || new_name);
    end loop;
end
$$
language plpgsql;

call copy_and_date();

-- Создать хранимую процедуру, которая, не уничтожая базу данных, уничтожает 
-- все те таблицы текущей базы данных в схеме 'dbo', имена которых начинаются с 
-- фразы 'TableName'. Созданную хранимую процедуру протестировать. 

create or replace procedure remove_table(tablename varchar)
AS
$$
declare
    element varchar;
begin
    for element in execute 'select table_name from information_schema.tables
                            where table_type = ''BASE TABLE'' AND table_name like '''|| tablename || '%'''
    loop
        execute 'drop table ' || element;
    end loop;
end
$$
language plpgsql;

call remove_table('TableName');

-- Создать хранимую процедуру с входным параметром – "имя таблицы",
-- которая удаляет дубликаты записей из указанной таблицы в текущей
-- базе данных. Созданную процедуру протестировать.

create or replace procedure delete_double(tablename varchar)
AS
$$
begin
    execute 'create table new_table as select distinct * 
                                        from ' || tablename;
    execute 'drop table ' || tablename;
    execute 'alter table new_table rename to ' || tablename;
end
$$
language plpgsql;
call delete_double('test');

-- Создать хранимую процедуру с выходным параметром, которая уничтожает
-- все представления в текущей базе данных. Выходной параметр возвращает
-- количество уничтоженных представлений. Созданную хранимую процедуру
-- протестировать. 

create or replace procedure delete_view(count_ inout int)
AS
$$
declare
    name_view record;
    cur cursor for 
        select viewname
        from pg_catalog.pg_views
        where schemaname <> 'pg_catalog'
        and schemaname <> 'information_schema';
begin
    open cur;
    loop 
        fetch cur into name_view;
        exit when not found;
        count_ = count_ + 1;
        execute 'drop view ' || name_view.viewname;
    end loop;
    close cur;
end
$$
language plpgsql;

call delete_view(0);

-- Создать хранимую процедуру с выходным параметром, которая уничтожает 
-- все SQL DDL триггеры (триггеры типа 'TR') в текущей базе данных. Выходной
--  параметр возвращает количество уничтоженных триггеров. Созданную хранимую 
-- процедуру протестировать. 

create or replace procedure drop_ddl_trigger(_count inout int)
as 
$$
declare 
	rec record;
	cur cursor for select * from information_schema.triggers t
					where t.event_manipulation = 'CREATE' OR 
                    t.event_manipulation = 'ALTER' OR
                    t.event_manipulation = 'DROP';
begin
    open cur;
	loop    
		fetch cur into rec;
		exit when not found;
		execute 'drop trigger ' || rec.trigger_name || ' on ' || rec.event_object_table;
	end loop;
    close cur;
end

$$
language plpgsql;

call drop_ddl_trigger(0);

-- Создать хранимую процедуру с входным параметром, которая выводит
-- имена и описания типа объектов (только хранимых процедур и скалярных
-- функций), в тексте которых на языке SQL встречается строка, задаваемая
-- параметром процедуры. Созданную хранимую процедуру протестировать. 

create or replace procedure get_info(str varchar)
as
$$
declare 
    rec record;
    cur cursor for select routine_name, routine_type
                from information_schema.routines
                where routine_name like '%' || str || '%';
begin
    open cur;
    loop
	    fetch cur into rec;
	    exit when not found;
        raise notice 'element: %, %', rec.routine_name, rec.routine_type;
    end loop;
    close cur;
end
$$
language plpgsql;

call get_info('delete_double');

