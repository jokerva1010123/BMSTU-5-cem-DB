/*
	Создать, развернуть триггер CLR
	Удалить сотрудника с фамилией ...
*/

drop trigger if exists delete_vet_new on vets_user;

drop function if exists delete_vet_new();

create or replace view vets_user as
select *
from veterinarians
where id_vet < 100;

create or replace function delete_vet_new()
returns trigger as
$$
	old_surname = TD["old"]["surname"]
	plpy.notice(f"Уволен сотрудник {old_surname}")
	
	plpy.execute(f"update vets_user \
				   set cabinet = 0 \
				   where surname = {old_surname};")
				   
	return TD["new"]
$$
language plpython3u;

create trigger delete_vet_new
instead of delete on vets_user
for each row
execute procedure delete_vet_new();

delete
from vets_user as vet
where vet.surname = 'Абрамова';

select *
from veterinarians