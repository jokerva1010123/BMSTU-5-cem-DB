/*
	Выполнить проверку существования узла или атрибута
	Проверить, существует ли животное с именем Арчи
*/

drop function if exists if_key_exists(id_in varchar, key_in jsonb);

CREATE or replace FUNCTION if_key_exists(id_in varchar, key_in jsonb)
RETURNS boolean
AS $$
BEGIN
    return(select count(*)
			 from animals_import
 			 where animals_import.doc->>'id' like id_in and animals_import.doc::jsonb @> key_in
         ) AS cnt;
END;
$$ LANGUAGE PLPGSQL;

select if_key_exists('1', '{"animal_name": "Арчи"}'::jsonb);