-- 22. Инструкция SELECT, использующая простое обобщенное табличное выражение

with root_files as (
	select *
	from fs.inodes
	where parent_inode = 0
)
select inode, root_files.name, size, types.name as type
from root_files join fs.types on root_files.type_id = fs.types.id;
