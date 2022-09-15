-- Insert from json
truncate table fs.groups cascade;
truncate table fs.types cascade;
truncate table fs.users cascade;
truncate table fs.users_groups cascade;
truncate table fs.inodes cascade;

drop table if exists temp_json;
create or replace function fill_json(in t_name varchar, in f_path varchar) returns void
    language plpgsql
as
$$
declare
    create_tmp_table text;
    copy_query       text;
    insert_query     text;
begin
    create_tmp_table = 'create temporary table temp_json (values json) on commit drop;';
    execute create_tmp_table;
    copy_query = 'copy temp_json from ''' || f_path || ''';';
    execute copy_query;
    insert_query = 'insert into ' || t_name || ' (select p.* from temp_json cross join json_populate_record(null::' ||
                   t_name || ', values) as p);';
    execute insert_query;
end
$$;

select fill_json('fs.groups', '/home/user/bmstu/DB/lab05/groups.json');
select fill_json('fs.types', '/home/user/bmstu/DB/lab05/types.json');
select fill_json('fs.users', '/home/user/bmstu/DB/lab05/users.json');
select fill_json('fs.inodes', '/home/user/bmstu/DB/lab05/inodes.json');
select fill_json('fs.users_groups', '/home/user/bmstu/DB/lab05/users_groups.json');

-- Insert from XML
truncate table fs.groups cascade;
truncate table fs.types cascade;
truncate table fs.users cascade;
truncate table fs.users_groups cascade;
truncate table fs.inodes cascade;

INSERT INTO fs.types
  SELECT (xpath('//row/id/text()', x))[1]::text::int AS id,
         (xpath('//row/name/text()', x))[1]::text AS name,
         (xpath('//row/shortcut/text()', x))[1]::text AS shortcut
  FROM unnest(xpath('//row', pg_read_file('/home/user/bmstu/DB/lab05/user_fs_types.xml'::text, 0,
      (select size from pg_stat_file('/home/user/bmstu/DB/lab05/user_fs_types.xml'))-3)::xml)) x;

INSERT INTO fs.users
  SELECT (xpath('//row/id/text()', x))[1]::text::int AS id,
         (xpath('//row/name/text()', x))[1]::text AS name
  FROM unnest(xpath('//row', pg_read_file('/home/user/bmstu/DB/lab05/user_fs_users.xml'::text, 0,
      (select size from pg_stat_file('/home/user/bmstu/DB/lab05/user_fs_users.xml'))-3)::xml)) x;

INSERT INTO fs.groups
  SELECT (xpath('//row/id/text()', x))[1]::text::int AS id,
         (xpath('//row/name/text()', x))[1]::text AS name
  FROM unnest(xpath('//row', pg_read_file('/home/user/bmstu/DB/lab05/user_fs_groups.xml'::text, 0,
      (select size from pg_stat_file('/home/user/bmstu/DB/lab05/user_fs_groups.xml'))-3)::xml)) x;

INSERT INTO fs.inodes
  SELECT (xpath('//row/inode/text()', x))[1]::text::int AS inode,
         (xpath('//row/name/text()', x))[1]::text AS name,
         (xpath('//row/size/text()', x))[1]::text::int AS size,
         (xpath('//row/parent_inode/text()', x))[1]::text::int AS parent_inode,
         (xpath('//row/type_id/text()', x))[1]::text::int AS type_id,
         (xpath('//row/owner_id/text()', x))[1]::text::int AS owner_id,
         (xpath('//row/group_id/text()', x))[1]::text::int AS group_id
  FROM unnest(xpath('//row', pg_read_file('/home/user/bmstu/DB/lab05/user_fs_inodes.xml'::text, 0,
      (select size from pg_stat_file('/home/user/bmstu/DB/lab05/user_fs_inodes.xml'))-3)::xml)) x;

INSERT INTO fs.users_groups
  SELECT (xpath('//row/id/text()', x))[1]::text::int AS id,
         (xpath('//row/user_id/text()', x))[1]::text::int AS user_id,
         (xpath('//row/group_id/text()', x))[1]::text::int AS group_id
  FROM unnest(xpath('//row', pg_read_file('/home/user/bmstu/DB/lab05/user_fs_users_groups.xml'::text, 0,
      (select size from pg_stat_file('/home/user/bmstu/DB/lab05/user_fs_users_groups.xml'))-3)::xml)) x;
