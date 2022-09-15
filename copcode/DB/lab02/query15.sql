-- 15. Instruction SELECT using HAVING
-- count directories and regular files

select types.name, count(*)
from fs.inodes join fs.types on inodes.type_id = types.id
group by types.name
having count(*) > 1000;
