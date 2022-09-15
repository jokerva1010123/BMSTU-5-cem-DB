-- 9. Instruction SELECT using simple CASE

select
	inode,
	case type_id
		when 0 then concat(shortcut, 'rw-r--r--')
		when 1 then concat(shortcut, 'rwxr-xr-x')
	end as access,
	fs.inodes.name
from fs.inodes join fs.types on inodes.type_id = types.id;
