-- XML Schemas типа как из Visual Studio
select table_to_xmlschema((select oid from pg_class where relname = 'groups'), true, true, ''::text);
select table_to_xmlschema((select oid from pg_class where relname = 'inodes'), true, true, ''::text);
select table_to_xmlschema((select oid from pg_class where relname = 'types'), true, true, ''::text);
select table_to_xmlschema((select oid from pg_class where relname = 'users'), true, true, ''::text);
select table_to_xmlschema((select oid from pg_class where relname = 'users_groups'), true, true, ''::text);
