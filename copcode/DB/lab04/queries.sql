create extension plpythonu;


-- Определяемая пользователем скалярная функция CLR
drop function if exists fs.avg_files_extensions_size;

create or replace function fs.avg_files_extensions_size(extension text) returns numeric
	language plpythonu
as $$
query = "select size from fs.inodes where name like '%.{}';".format(extension)
print(query)
cursor = plpy.cursor(query)
sum = 0
number = 0
while True:
    rows = cursor.fetch(100)
    if not rows:
        break
    for row in rows:
        number += 1
        print(row['size'])
        sum += int(row['size'])
return sum / number
$$;

select fs.avg_files_extensions_size('mp3');


-- Пользовательская агрегатная функция CLR
drop function if exists avg_state;

create or replace function avg_state(prev numeric[2], next numeric) returns numeric[2] as $$
return prev if next == 0 or next == None else [0 if prev[0] == None else prev[0] + next, prev[1] + 1]
$$ language plpythonu;

drop function if exists avg_final;

create or replace function avg_final(num numeric[2]) returns numeric as $$
return 0 if num[1] == 0 else num[0] / num[1]
$$ language plpythonu;

drop aggregate if exists my_avg(numeric);

create aggregate my_avg(numeric) (
sfunc = avg_state,
	stype = numeric[],
	finalfunc =avg_final,
	initcond = '{0,0}'
);

select my_avg(size::numeric)
from fs.inodes
where name like '%.txt';


-- Определяемая пользователем табличная функция CLR
drop function if exists fs.all_files_extensions(extension text, lim integer);

create or replace function fs.all_files_extensions(extension text, lim int)
returns table (
	inode integer,
	name character varying,
	size bigint,
	parent_inode integer,
	type_id integer,
	owner_id integer,
	group_id integer
)
as $$
query = "select * from fs.inodes where name like '%.{}';".format(extension)
result = plpy.execute(query, lim)
return result
$$ language plpythonu;

select fs.all_files_extensions('txt', 10);


-- Хранимая процедура CLR
drop procedure if exists fs.up_files_extensions_size(extension text, lim int);

create or replace procedure fs.up_files_extensions_size(inout a int, inout b int) as $$
query = "update fs.inodes set size = size * 2 where name like '%.{}';".format(extension)
result = plpy.execute(query, lim)
return result
$$ language plpythonu;


-- Триггер CLR
drop function if exists fs.null_parent_inode;

create or replace function fs.null_parent_inode() returns trigger as
$null_parent_inode$
query = 'select count(*) from fs.inodes where inode = {} and parent_inode is null'.format(TD["new"]["inode"])
count = plpy.execute(query, 1)
if count:
    del_query = 'delete from fs.inodes where inode = {} and parent_inode is null'.format(TD["new"]["inode"])
    plpy.execute(del_query, 1)
return None
$null_parent_inode$ language plpythonu;

drop trigger if exists null_parent_inode on fs.inodes;

create trigger null_parent_inode
	after insert or update
	on fs.inodes
	for each row
execute procedure fs.null_parent_inode();

insert
into fs.inodes
(name, size, parent_inode, type_id, owner_id, group_id)
values
('kek', 1024, null, 0, 0, 0);


-- Определяемый пользователем тип данных CLR
drop type if exists File cascade;

create type File; -- "(name, content)"

create or replace function file_in(cstring) returns File
as '/home/user/bmstu/DB/lab04/file.so', 'file_in'
language C immutable strict;

create or replace function file_out(File) returns cstring
as '/home/user/bmstu/DB/lab04/file.so', 'file_out'
language C immutable strict;

create or replace function file_recv(internal) returns File
as '/home/user/bmstu/DB/lab04/file.so', 'file_recv'
language C immutable strict;

create or replace function file_send(File) returns bytea
as '/home/user/bmstu/DB/lab04/file.so', 'file_send'
language C immutable strict;

create type File (
	internallength = 1280,
	input = file_in,
	output = file_out,
	receive = file_recv,
	send = file_send
);

with a as (
	select array[fs.inodes.name, fs.users.name, fs.groups.name] as x
	from fs.inodes
		join fs.users on inodes.owner_id = users.id
		join fs.groups on inodes.group_id = groups.id
	where inode = 1000
)
select format('[%s] --owner: %s-- --group: %s--', x[1], x[2], x[3])File
from a;
