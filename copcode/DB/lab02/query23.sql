-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
-- расположение файла с максимальным inode

with recursive path as (
	select 0 as depth, inodes.inode, inodes.name, inodes.parent_inode, types.name as type_name
	from fs.inodes join fs.types on inodes.type_id = types.id
	where inode = (
		select inode
		from fs.inodes
		order by inode desc
		limit 1
	) -- can't write this directly inside with recursive :(

	union all

	select path.depth + 1, inodes.inode, inodes.name, inodes.parent_inode, types.name as type_name
	from fs.inodes
		join path on inodes.inode = path.parent_inode
		join fs.types on inodes.type_id = types.id
	where inodes.inode is not null
)
select * from path;
