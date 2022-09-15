alter table fs.users
	add constraint name_not_empty check (name != '');

alter table fs.groups
	add constraint name_not_empty check (name != '');

alter table fs.inodes
	add constraint name_not_empty check (name != '');
