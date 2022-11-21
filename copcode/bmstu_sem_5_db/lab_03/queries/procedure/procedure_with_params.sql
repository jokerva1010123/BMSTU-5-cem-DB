--хранимая процедура с параметрами или без
--выполнить повышение в должности нескольких врачей
--выполнить понижение должности нескольких врачей
create or replace procedure update_vet_post(vet_surname varchar(30)) as
$$
begin
	update veterinarian
	set qualification = (select case when qualification = 'Без категории' then 'Вторая'
									 when qualification = 'Вторая' then 'Первая'
									 when qualification = 'Первая' then 'Высшая'
								end) 
	where veterinarian.surname = vet_surname;						 
end;
$$
language plpgsql;

call update_vet_post('Абакумов');