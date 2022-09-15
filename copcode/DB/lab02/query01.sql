-- 1. Instruction SELECT using comparison predicate
-- select all files

select *
from fs.inodes
where type_id = 0;
