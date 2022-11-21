--хранимая процедура с курсором
--вывести всех животных вида "кошка" и "собака".

create or replace procedure output(kind_animal_first varchar(30), kind_animal_second varchar(30)) as
$$
declare
	kind_list record;
	kind_cursor cursor for
		select *
		from animals
		where animals.kind = kind_animal_first or animals.kind = kind_animal_second;
	
begin
	open kind_cursor;
	loop
		fetch kind_cursor into kind_list;
		raise notice '% %', kind_list.kind, kind_list.animal_name;
		exit when not found;
	end loop;
	close kind_cursor;
	
end;
$$
language plpgsql;

call output('Кошка', 'Собака');