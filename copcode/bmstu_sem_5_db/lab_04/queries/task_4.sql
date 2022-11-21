/*
	Создать, развернуть хранимую процедуру CLR
	Выполнить повышение в должности ветеринара.
*/

create or replace procedure update_vet_post_new(vet_surname varchar(30)) as
$$
	plan = plpy.prepare("update veterinarians \
						set qualification = (select case when qualification = 'Без категории' then 'Вторая' \
											 			when qualification = 'Вторая' then 'Первая' \
											 			when qualification = 'Первая' then 'Высшая' end) \
											 where veterinarians.surname = $1;",
						["varchar"])
	plpy.execute(plan, [vet_surname])
$$
language plpython3u;

call update_vet_post_new('Абрикосов');