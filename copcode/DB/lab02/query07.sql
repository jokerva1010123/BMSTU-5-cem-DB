-- 7. Instruction SELECT using aggregate functions
-- select fs size

select sum(size) fs_size
from fs.inodes;
