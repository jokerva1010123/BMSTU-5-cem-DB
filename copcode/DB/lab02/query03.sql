-- 3. Instruction SELECT using LIKE predicate
-- select all .mp3 files

select *
from fs.inodes
where name like '%.mp3';
