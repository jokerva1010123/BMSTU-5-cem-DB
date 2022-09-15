-- 13. Instruction SELECT using 3-depth subqueries in from
-- select all regular files, that are in the folder owned by user in group with name whose length is 3

select
	fs.inodes.*,
	parents.user_id parent_owner_id,
	parents.group_id parent_group_id,
	parents.group_name parent_group_name
from fs.inodes join (
	select distinct inode, users.*
	from fs.inodes join (
		select user_id, group_id, name as group_name
		from fs.users_groups join fs.groups on users_groups.group_id = groups.id
		where groups.name like '___'
	) users on owner_id = user_id
	where type_id = 1
) parents on fs.inodes.parent_inode = parents.inode
where type_id = 0;
