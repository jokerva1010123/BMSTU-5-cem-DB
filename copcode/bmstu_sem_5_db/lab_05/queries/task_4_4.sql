/*
	Изменить значение атрибута
*/

select * from animals_import
where (doc->>'id')::INT = 7;

-- Перезаписываем значение json поля.
update animals_import
set doc = doc::jsonb || '{"age": 6}'::jsonb
where (doc->>'id')::INT = 7;