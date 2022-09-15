create schema if not exists fs;

drop table if exists fs.inodes cascade;
drop table if exists fs.types cascade;
drop table if exists fs.users cascade;
drop table if exists fs.groups cascade;
drop table if exists fs.users_groups cascade;

-- вообще-то у пацанов табы шириной 8

create table fs.types (
	id		serial primary key,
	name		varchar(16) not null,
	shortcut	char not null
);

create table fs.users (
	id		serial primary key,
	name		varchar(32) not null
);

create table fs.groups (
	id		serial primary key,
	name		varchar(32) not null
);

create table fs.users_groups (
	id		serial primary key,
	user_id		serial not null references fs.users(id),
	group_id	serial not null references fs.groups(id)
);

create table fs.inodes (
	inode		serial primary key,
	name		varchar(64) not null,
	size		bigint not null,
	parent_inode	integer references fs.inodes(inode),
	type_id		serial not null references fs.types(id),
	owner_id	serial not null references fs.users(id),
	group_id	serial not null references fs.groups(id)
);
