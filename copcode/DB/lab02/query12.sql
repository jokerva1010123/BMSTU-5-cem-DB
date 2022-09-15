-- 12. Instruction SELECT using subqueries in from
-- select all directories contains *.jpg

select inodes.*
from fs.inodes inodes join (
	select distinct parent_inode
	from fs.inodes
	where name like '%.jpg'
) dirs on dirs.parent_inode = inodes.inode;
