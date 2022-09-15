-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET

update fs.inodes
set size = (
	select avg(size)
	from fs.inodes
	where type_id = 0
)
where name = 'temp.txt';
