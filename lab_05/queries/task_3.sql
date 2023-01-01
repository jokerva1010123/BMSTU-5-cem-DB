/*
	Создать атрибуты, в которой будут атрибут(-ы) с типом json или добавить атрибут
	с типом json к уже существующей таблице. Заполнить атрибут правдоподобными
	значениями с помощью команд insert или update.
*/

create table if not exists dop_json
(
	data json
);

select * from dop_json;

insert into dop_json
select * from json_object('{animal_id, animal_name, kind}', '{2, "Арчи", "Собака"}');