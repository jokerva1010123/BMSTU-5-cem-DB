--вывести приоритет вет. персонала (по подчинению)

drop function if exists recursion();
drop table if exists vets_submission;

create temp table if not exists vets_submission
(
	id_vet int primary key,
	boss_id_vet int references vets_submission(id_vet),
	surname varchar(20)
);

insert into vets_submission(id_vet, boss_id_vet, surname)
values
(0, null, 'Абрамова'),
(1, 0, 'Абакумов'),
(2, 3, 'Аверкова'),
(3, 0, 'Аврамов'),
(4, 2, 'Абрикосов'),
(5, 4, 'Абросимова'),
(6, 1, 'Авдеева');


create or replace function recursion()
returns table(id_vet int,
			  boss_id_vet int,
			  vet_surname varchar(30),
			  level int) as
$$
begin
	return query
	with recursive vs_rec(id_vet, boss_id_vet, vet_surname, level) as 
	(
		select vets_s.id_vet, vets_s.boss_id_vet, vets_s.surname, 0
		from vets_submission as vets_s
		where vets_s.boss_id_vet is null
		
		union all
		select vets_submission.id_vet, vets_submission.boss_id_vet, vets_submission.surname, vs_rec.level + 1
		from vs_rec join vets_submission on vs_rec.id_vet = vets_submission.boss_id_vet
	)
	
	select *
	from vs_rec;
end;
$$
language plpgsql;

select *
from recursion()
