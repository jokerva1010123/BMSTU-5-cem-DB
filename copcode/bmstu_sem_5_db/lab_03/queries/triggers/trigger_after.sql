--DML триггер AFTER
--вывести информацию при обновлении ...

drop trigger if exists update_vet_qualification on veterinarian;

create or replace function update_vet_qualification()
returns trigger as
$$
begin
	raise notice 'Old: %', old.qualification;
	raise notice 'New: %', new.qualification;
	
	return new;
end;
$$
language plpgsql;

create trigger update_vet_qualification
	after update on veterinarian
	for each row
	execute procedure update_vet_qualification();
	
update veterinarian
set qualification = 'Первая'
where id_vet = 1;

--select *
--from veterinarian