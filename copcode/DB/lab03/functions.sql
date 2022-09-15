-- Скалярная функция
drop function if exists fs.avg_files_extensions_size;

create function fs.avg_files_extensions_size(extension text) returns numeric
	stable
	strict
	language sql
as $$
	select sum(size) / count(*)
	from fs.inodes
	where name like concat('%.', extension);
$$;

select * from fs.avg_files_extensions_size('mp3');


-- Подставляемая табличная функция
drop function if exists fs.all_files_extensions;

create function fs.all_files_extensions(extension text)
returns table(
	inode integer,
	name character varying,
	size bigint,
	parent_inode integer,
	type_id integer,
	owner_id integer,
	group_id integer
)
	stable
	strict
	language sql
as
$$
	select *
	from fs.inodes
	where name like concat('%.', extension);
$$;

select * from fs.all_files_extensions('mp3');


-- Многооператорная табличная функция
drop function if exists fs.p_all_files_extensions;

create function fs.p_all_files_extensions(extension text)
returns table(
	inode integer,
	filename character varying,
	size bigint,
	parent_inode integer,
	type_id integer,
	owner_id integer,
	group_id integer
)
	stable
	strict
	language plpgsql
as
$$
begin
	return query
		select *
		from fs.inodes
		where name like concat('%.', extension);
end;
$$;

select * from fs.p_all_files_extensions('mp3');


-- Рекурсивная функция или функция с рекурсивным ОТВ
drop function if exists fs.get_path;

create function fs.get_path(inode_ integer)
returns table(
	depth integer,
	inode integer,
	name character varying,
	parent_inode integer,
	type_name character varying
)
	stable
	strict
	language sql
as
$$
with recursive path as (
	select 0 as depth, inodes.inode, inodes.name, inodes.parent_inode, types.name as type_name
	from fs.inodes join fs.types on inodes.type_id = types.id
	where inode = inode_

	union all

	select path.depth + 1, inodes.inode, inodes.name, inodes.parent_inode, types.name as type_name
	from fs.inodes
		join path on inodes.inode = path.parent_inode
		join fs.types on inodes.type_id = types.id
	where inodes.inode is not null
)
select * from path;
$$;

select * from fs.get_path(1000);


-- Хранимая процедура без параметров или с параметрами
drop procedure if exists fs.delete_duplicates();

create procedure fs.delete_duplicates()
	language sql
as
$$
delete from fs.users_groups
where id in (
	select users_groups.id
	from fs.users_groups
		join (
			select
				id,
				row_number() over (partition by user_id, group_id order by id) rn
			from fs.users_groups
		) ug on users_groups.id = ug.id
	where rn > 1
);
$$;

-- Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
drop procedure if exists fs.useless_recursive(n integer);

create procedure fs.useless_recursive(n integer)
language plpgsql as $$
begin
	if (n < 10) then
		update fs.inodes set size = size * 2 where inode = n;
		call useless_recursive(n + 1);
	end if;
end;
$$;

-- Хранимая процедура с курсором
drop procedure if exists fs.up_files_extensions_size();
create procedure fs.up_files_size(extension text)
language plpgsql as $$
declare
	curs cursor for
		select *
		from fs.inodes
		where name like concat('%.', extension);
begin
	open curs;
	update fs.inodes set size = size * 2 where current of curs;
	close curs;
end;
$$;


-- Хранимая процедура доступа к метаданным
drop procedure if exists fs.table_info(in name text);

create procedure fs.table_info(in name text)
language plpgsql as $$
declare
	c record;
begin
	select table_catalog, table_schema into c from information_schema.columns where table_name = name;
	raise notice 'Catalog: %, schema: %', c.table_catalog, c.table_schema;
end;
$$;

call fs.table_info('inodes');


-- Триггер AFTER
drop function if exists fs.delete_empty_files;

create function fs.delete_empty_files() returns trigger as
$delete_empty_files$
declare
	files_number integer;
begin
	select count(*)
	into files_number
	from fs.inodes
	where size = 0;

	if (files_number = 0) then
		delete
		from fs.inodes
		where size = 0;
	end if;

	return null;
end;
$delete_empty_files$ language plpgsql;

drop trigger if exists check_number on fs.inodes;

create trigger check_number
	after delete
	on fs.inodes
execute procedure fs.delete_empty_files();


-- Триггер INSTEAD OF
drop view if exists fs.inodes_view;

create view fs.inodes_view as
select *
from fs.inodes;

drop function if exists fs.deny_delete;

create function fs.deny_delete() returns trigger as
$deny_delete$
begin
	raise notice 'deleting denied';
end
$deny_delete$ language plpgsql;

drop trigger deny_delete
on fs.inodes_view;

create trigger deny_delete
instead of delete
on fs.inodes_view
for each row
execute procedure fs.deny_delete();
