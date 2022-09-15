-- 25. Оконные функции для устранения дублей

select setval('fs.users_groups_id_seq', max(id))
from fs.users_groups;

insert
into fs.users_groups (user_id, group_id)
select user_id, group_id
from fs.users_groups
where id < 10;

delete from fs.users_groups
where id in (
	select users_groups.id
	from fs.users_groups
		join (
			select
				id,
				row_number() over (partition by user_id, group_id order by id) rn
			from fs.users_groups
		) ug on users_groups.id = ug.id
	where rn > 1
);
