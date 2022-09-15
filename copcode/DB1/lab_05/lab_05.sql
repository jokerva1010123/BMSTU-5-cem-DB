-- Задание №1. Из таблиц базы данных, созданной в первой лабораторной работе,
-- извлечь данные в JSON.

-- Извлёк данные из таблицы employee в файл employee.json

copy (select row_to_json(employee) from employee)
    to '/Users/Alex/Documents/BD/lab_05/jsons/employee.json';

-- Задание №2. Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице базы данных,
-- созданной в первой лабораторной работе.

-- Создание временной таблицы с значениями json из файла.
create table employee_json_temp(row json);
copy employee_json_temp from '/Users/Alex/Documents/BD/lab_05/jsons/employee.json';

-- Парсим json-ы и добавляем в результирующую таблицу.
select X.id_employee, X.id_institution, X.full_name, X.func, X.dob, X.gender, X.phone,
       X.experience, X.education
into employee_json
from employee_json_temp J, json_to_record(J.row)
as X(id_employee integer, id_institution integer, full_name varchar(50), func varchar(25),
     dob date, gender char(3), phone char(18), experience interval, education varchar(100));

select * from employee;
select * from employee_json;

-- Задание №3. Создать таблицу, в которой будет атрибут(-ы) с типом JSON,
-- или добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

select * from child;

-- Создал временную копию таблицы child с атрибутом json
create temp table if not exists child_with_json_temp (
    id_child serial primary key not null,
    full_name varchar(50) not null,
    gender char(3) not null,
    dob json not null
);

-- Добавил все строки из старой таблицы child, но из даты рождения сделал json объект
insert into child_with_json_temp (id_child, full_name, gender, dob)
select id_child, full_name, gender,
       json_build_object(
           'day', extract(day from dob),
           'month', extract(month from dob),
           'year', extract(year from dob)
           )
from child;

select * from child_with_json_temp;

-- Задание №4. Выполнить следующие действия:
-- 1. Извлечь JSON фрагмент из JSON документа.

-- Вывести один json фрагмент из документа созданного в первом задании.
select *
from employee_json_temp
limit 1;

-- 2. Извлечь значения конкретных узлов или атрибутов JSON документа.

-- Вывести ФИО работников женского пола. Использовался JSON документ из первого задания.
select row->>'full_name' as full_name, row->>'gender' as gender
from employee_json_temp
where row->>'gender' = 'жен';

-- 3. Выполнить проверку существования атрибута.

-- Добавил два столбца с информацией о существовании необходимых атрибутов.
select row,
       row::jsonb ? 'full_name' as full_name_exists,
       row::jsonb ? 'name' as name_exists
from employee_json_temp;

-- 4. Изменить JSON документ.

create temp table person_info_json (
    person json
);

insert into person_info_json(person)
values ('{"name":"Алексей","surname":"Пиксаев"}'),
       ('{"name":"Дарья","surname":"Дорогова"}'),
       ('{"name":"Ольга","surname":"Капичникова"}');

select * from person_info_json;

-- Заменил фамилию на свою.
update person_info_json
set person = jsonb_set(person::jsonb, '{surname}', '"Воякин"', false)
where person->>'surname' = 'Пиксаев';


-- 5. Разделить JSON документ на несколько строк по узлам.


select * from employee_json_temp;


copy (
    select *
    from employee_json_temp
    where (row->>'dob')::date > '1980-01-01'
    )
to '/Users/Alex/Documents/BD/lab_05/jsons/employee_young.json';


select X.id_employee, X.id_institution, X.full_name, X.func, X.dob, X.gender, X.phone,
       X.experience, X.education
into employee_json
from employee_json_temp J, json_to_record(J.row)
as X(id_employee integer, id_institution integer, full_name varchar(50), func varchar(25),
     dob date, gender char(3), phone char(18), experience interval, education varchar(100));


select json_build_object(
            'id_employee', id_employee,
            'id_institution', id_institution
           ) as identifiers,
       json_build_object(
           'full_name', full_name,
           'func', func,
           'dob', dob,
           'gender', gender,
           'phone', phone,
           'experience', experience,
           'education', education
           ) as desctription
from employee_json_temp J, json_to_record(J.row)
as X(id_employee integer, id_institution integer, full_name varchar(50), func varchar(25),
     dob date, gender char(3), phone char(18), experience interval, education varchar(100));