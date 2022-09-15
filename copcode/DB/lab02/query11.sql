-- 11. Instruction SELECT using local temp table
-- select file's size of each owner

select
	owners.id user_id,
	owners.name user_name,
	(
		select sum(size) user_files_size
		from fs.inodes inner_q
		where inner_q.owner_id = outer_q.owner_id
	)
into temp temp_table
from fs.inodes outer_q join fs.users owners on outer_q.owner_id = owners.id;

drop table temp_table;
