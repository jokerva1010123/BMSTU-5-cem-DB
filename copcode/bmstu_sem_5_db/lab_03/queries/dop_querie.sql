--создать процедуру;
--вход: имя животного, его диагноз
--выход: наименование лечения 

create or replace procedure output_animal_name(input_animal_name varchar(30),
											  	input_diagnosis varchar(30)) as
$$
declare
	treatment_list record;
	treatment_cursor cursor for
		select *
		from animals join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis
					 join treatment on animals.id_treatment = treatment.id_treatment	
		where animals.animal_name = input_animal_name and diagnosis.name = input_diagnosis;
	
begin
	open treatment_cursor;
	loop
		fetch treatment_cursor into treatment_list;
		raise notice '% % %', treatment_list.animal_name, treatment_list.name, treatment_list.treatment_name;
		exit when not found;
	end loop;
	close treatment_cursor;
		
end;
$$
language plpgsql;

call output_animal_name('Арчи', 'Синдром Маллори-Вейсса');