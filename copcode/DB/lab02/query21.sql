-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE

delete
from fs.inodes
where inode in (
	select inode
	from fs.inodes
	where parent_inode is null and inode > 0
);
