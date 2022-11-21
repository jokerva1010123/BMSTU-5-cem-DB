--DML триггер INSTEAD OF
--сотрудник с фамилией ... уволился из данной больницы

drop trigger if exists delete_vet on vets_user;

drop function if exists delete_vet();

create or replace view vets_user as
select *
from veterinarian
where id_vet < 100;

create function delete_vet()
returns trigger as
$$
begin
	raise notice 'Уволен сотрудник %.', old.surname;
	
	update vets_user
	set cabinet = 0
	where surname = old.surname;
	
	return new;
end;
$$
language plpgsql;

create trigger delete_vet
instead of delete on vets_user
for each row
execute procedure delete_vet();

delete
from vets_user as vet
where vet.surname = 'Аксёнова';