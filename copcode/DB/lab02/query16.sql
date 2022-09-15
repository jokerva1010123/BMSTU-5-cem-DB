-- 16. Instruction INSERT

select setval('fs.inodes_inode_seq', max(inode))
from fs.inodes;

insert
into fs.inodes (name, size, parent_inode, type_id, owner_id, group_id)
values ('root2', 4096, null, 1, 0, 0);
