-- 5. Instruction SELECT using EXIST predicate with nested subquery
-- select all non-empty directories

select *
from fs.inodes outer_q
where exists (
	select *
	from fs.inodes inner_q
	where inner_q.parent_inode = outer_q.inode
);
