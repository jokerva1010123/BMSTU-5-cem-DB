-- 2. Instruction SELECT using BETWEEN predicate
-- select files with size between 1Kb and 2Kb

select *
from fs.inodes
where type_id = 0 and size between 1024 and 2048;
