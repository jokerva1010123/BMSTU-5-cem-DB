-- 6. Instruction SELECT using comparison predicate with quantor
-- select files with size less than each *.png

select *
from fs.inodes
where size < all(
	select size
	from fs.inodes
	where name like '%.png'
);
