create database rk2;

create table if not exists parents(
    id_parent int primary key,
    fio varchar,
    age int,
    type varchar
);

create table if not exists group_child(
    id int primary key,
    name varchar,
    fio_teacher varchar,
    max_time int
);

create table if not exists child(
    id_child int primary key,
    fio varchar,
    birthday int,
    gender varchar,
    addres varchar,
    id_kafedra int,
    foreign key(id_kafedra) references group_child(id)
);

create table if not exists parents_child(
    id_parent int,
    foreign key (id_parent) references parents(id_parent),

    id_child int,
    foreign key (id_child) references child(id_child)
);

insert into parents (
    id_parent, fio, age, type
)
values
(1, 'A1', 30, 'mom'),
(2, 'A2', 31, 'mom'),
(3, 'A3', 32, 'mom'),
(4, 'A4', 33, 'mom'),
(5, 'A5', 34, 'mom'),
(6, 'A6', 35, 'dad'),
(7, 'A7', 36, 'dad'),
(8, 'A8', 37, 'dad'),
(9, 'A9', 38, 'dad'),
(10, 'A10', 39, 'dad');

insert into group_child (
    id, name, fio_teacher, max_time
)
values
(1, 'G1', 'Teacher1', 11),
(2, 'G2', 'Teacher2', 12),
(3, 'G3', 'Teacher3', 13),
(4, 'G4', 'Teacher4', 14),
(5, 'G5', 'Teacher5', 15),
(6, 'G6', 'Teacher6', 16),
(7, 'G7', 'Teacher7', 17),
(8, 'G8', 'Teacher8', 18),
(9, 'G9', 'Teacher9', 19),
(10, 'G10', 'Teacher10', 10);

insert into child (
    id_child, fio, birthday, gender, addres, id_kafedra
)  
values
(1, 'C1', 1, 'male', '12 ABC', 1), 
(2, 'C2', 12, 'female', '14 CDF', 2), 
(3, 'C3', 13, 'male', '43 NJP', 3), 
(4, 'C4', 14, 'female', '19 VNM', 4), 
(5, 'C5', 15, 'male', '21 SIN', 5), 
(6, 'C6', 16, 'female', '10 RUS', 6), 
(7, 'C7', 17, 'male', '1 USA', 7), 
(8, 'C8', 18, 'female', '19 SWT', 8), 
(9, 'C9', 19, 'male', '22 CAM', 9), 
(10, 'C10', 11, 'female', '9 LAO', 10);

insert into parents_child(
    id_parent,
    id_child
)
values
(1, 1),
(6, 1),
(2, 2),
(7, 2),
(3, 3),
(8, 3),
(4, 4),
(9, 4),
(5, 5),
(10, 5),
(1, 6),
(6, 6),
(2, 7),
(7, 7),
(3, 8),
(8, 8),
(4, 9),
(9, 9),
(5, 10),
(10, 10);

-- Инструкция SELECT, использующая поисковое выражение case
-- Описать группы в зависимости от ее максимального количества часов: дешевая/средняя/дорогая
select group_child.id, group_child.name, 
		case
		when group_child.max_time < 13 then 'Быстро'
		when group_child.max_time > 15 then 'Медленно'
		else 'Средно'
		end as description_group
from group_child;

-- Инструкция UPDATE со скалярным подзапросом в предложении SET
-- изменить максимальное количество часов группы, имееющей id = 3, на новыое значение
update group_child
set max_time = 
(
	SELECT MAX(max_time)
	FROM group_child
)
where id = 3;

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, и предложения HAVING
-- Получить количество папы
select parents.type, count(parents.type)
from parents
group by parents.type
having parents.type = 'dad';

-- Создать хранимую процедуру без параметров, которая осуществляет поиск
-- ключевого слова 'EXEC' в тексте хранимых процедур в текущей базе
-- данных. Хранимая процедура выводит инструкцию 'EXEC', которая
-- выполняет хранимую процедуру или скалярную пользовательскую
-- функцию. Созданную хранимую процедуру протестировать. 

CREATE OR REPLACE PROCEDURE info_routine_exec
(
    str VARCHAR(32)
)
as
$$
DECLARE
    elem RECORD;
BEGIN
    FOR elem in
        SELECT routine_name, routine_type
        FROM information_schema.routines
        WHERE specific_schema = 'public'
        AND routine_type = 'PROCEDURE'
        AND routine_definition LIKE CONCAT('%', str, '%')
    LOOP
        RAISE NOTICE 'elem: %', elem;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL info_routine_exec('EXEC');