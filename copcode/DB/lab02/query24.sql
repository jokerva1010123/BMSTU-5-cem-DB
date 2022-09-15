-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

select
	*,
	row_number() over (partition by parent_inode order by name) as order_in_directory
from fs.inodes;
