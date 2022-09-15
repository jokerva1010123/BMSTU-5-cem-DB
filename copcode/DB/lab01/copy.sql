truncate table fs.types cascade;
truncate table fs.users cascade;
truncate table fs.groups cascade;
truncate table fs.users_groups cascade;
truncate table fs.inodes cascade;

-- run in psql (\i copy.sql)
\copy fs.types from 'types.csv' csv header;
\copy fs.users from 'users.csv' csv header;
\copy fs.groups from 'groups.csv' csv header;
\copy fs.users_groups from 'users_groups.csv' csv header;
\copy fs.inodes from 'inodes.csv' csv header;
