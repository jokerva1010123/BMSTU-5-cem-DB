-- 10. Instruction SELECT using Search Case
-- verbose size

select
	inode,
	name,
	case
		when size <= 4096 then 'small'
		when size <= 32768 then 'medium'
		else 'large'
	end as size,
	parent_inode,
	type_id,
	owner_id,
	group_id
from fs.inodes;
