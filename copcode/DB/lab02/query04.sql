-- 4. Instruction SELECT using IN predicate with nested subquery
-- select files in root's children directories

select *
from fs.inodes
where type_id = 0 and parent_inode in (
	select inode
	from fs.inodes
	where type_id = 1 and parent_inode = 0
);
