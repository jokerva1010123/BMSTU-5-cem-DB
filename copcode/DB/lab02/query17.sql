-- 17. Instruction INSERT with many rows

insert
into fs.inodes (name, size, parent_inode, type_id, owner_id, group_id)
values (
	'tmp.txt', 1024, (
		select inode
		from fs.inodes
		where name = 'root2'
		limit 1
	), 0, 0, 0
);
