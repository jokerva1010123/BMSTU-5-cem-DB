-- Динь Вьет Ань, ИУ7И-54Б

--1. Инструкция SELECT, использующая предикат сравнения. 
--Получить всех кошек в возрасте до 5 лет
select animals.id, animals.kind, animals.age 
from animals
where animals.age <= 5 and animals.kind = 'Кошка'

--2. Инструкция SELECT, использующая предикат BETWEEN.
--Получить всех животных в возрасте от 5 до 10 лет
select animals.id, animals.kind, animals.age 
from animals
where animals.age between 5 and 10

--3. Инструкция SELECT, использующая предикат LIKE. 
--Получить id, название животных и вид, у кого была найдена Абсцесс и другие похожие заболевания
select id, animal_name, kind, diagnosis.name
from animals join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis  
where diagnosis.name like '%Абсцесс%'

--4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
--Получить id, вид, кого лечил врач с фамилией Олтухов
select animals.id, animals.kind, veterinarian.surname 
from animals join veterinarian on animals.id_vet = veterinarian.id_vet 
where veterinarian.surname in (select veterinarian.surname from veterinarian where veterinarian.surname = 'Олтухов')

--5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
--Существуют ли те животные, у которых обнаружили абсцессы на приеме
select animals.id, animals.animal_name, animals.kind, diagnosis.name
from animals join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis
where exists (select animals.animal_name from animals where diagnosis.name = 'Абсцесс')

--6. Инструкция SELECT, использующая предикат сравнения с квантором
--Вывести всех собак, которые старше кошки Айрон
select animals.id, animals.animal_name, animals.kind, animals.age 
from animals 
where animals.kind = 'Собака' and animals.age > all 
(
select animals.age 
from animals
where animals.kind = 'Кошка' and animals.animal_name = 'Айрон'
)

--7. Инструкция SELECT, использующая агрегатные функции в выражении столбцов
--Вычислить общее число енотов
select COUNT(animals.kind)
from animals
where animals.kind = 'Енот'

--8. Инструкция SELECT, использующая скалярные подзапросы в выражении столбцов
--Вывести все болезнь с количеством больных животных
select diagnosis.id_diagnosis, diagnosis.name, 
								(select count(animals.id_diagnosis)
								 from animals
								 where animals.id_diagnosis = diagnosis.id_diagnosis) as number_pet
from diagnosis

--9. Инструкция SELECT, использующая простое выражение case
--Вывести информацию о животном с дополнительным столбцом, в котором описан возраст (молодой/взрослый/пожилой)
select id, kind, animal_name,
			case age
			when (select max(age) 
				  from animals) then 'Пожилой'
			when (select min(age)
				  from animals)	then 'Молодой'
			else 'Взрослый'
			end as comment
from animals
order by age

--10. Инструкция SELECT, использующая поисковое выражение case
-- Описать дороговизну лечения в зависимости от её стоимости: дешевая/средняя/дорогая

select animals.id, animals.animal_name, treatment.cost, 
		case
		when treatment.cost < 3000 then 'Дешевая'
		when treatment.cost > 7000 then 'Дорогая'
		ele 'Средняя'
		end as cost_level
from animals join treatment on animals.id_treatment = treatment.id_treatment

--11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
--Выписать в отдельную таблицу число животных, имеющих один и тот же возраст
drop table if exists newtable;
select animals.age, COUNT(animals.id)
into newtable
from animals
group by animals.age
order by animals.age;
select * from newtable

--12. Интсрукция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
--Выборка животных, чье лечение стоит больше 9000
select animals.id, animals.kind, animals.animal_name, H.cost
from animals join (select treatment.id_treatment, treatment.cost
				   from treatment
				   where treatment.cost > 9000) as H on animals.id_treatment = H.id_treatment
				   
-- Защита
select animal_owner.id_owner , animal_owner.name, animal_name, H.hospitalization 
from animal_owner join animals on animals.id_owner = animal_owner.id_owner 
				join (select treatment.id_treatment, treatment.hospitalization 
				   from treatment
				   where treatment.hospitalization = 'Требуется') as H on animals.id_treatment = H.id_treatment
order by id_owner 
				
				   
--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
--Вывести животных, чье лечение болезни максимально по средней стоимости
select id, animal_name, kind
from animals
where id in (select id_treatment
	 from treatment
	 group by id_treatment
	 having avg(cost) = (select max(C)
		 				 from (select avg(cost) as C
		 				 	   from treatment
							   group by id_treatment)
							   as OD))
	
--14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
--Вывести количество каждого из вида животных
select animals.kind, count(animals.id)
from animals
group by animals.kind

--15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, и предложения HAVING
--Получить количество животных, чей возраст не превышает 10 лет 
select animals.age, count(animals.kind)
from animals
group by animals.age
having animals.age < 10
order by animals.age

--16. Однострочная инструкция INSERT,
--выполняющая вставку в таблицу одной строки значений.
INSERT INTO diagnosis(id_diagnosis, name, date, degree_severity, need_operation)
VALUES(1001, 'Страшное что-то', '2020-04-06', 'Тяжелая', 'Не требуется')

--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
insert into animals(id, id_diagnosis)
select id * 1000 as ID, id_diagnosis as DiagnosisID
from animals
where animals.kind = 'Енот' and id > 200 and id < 550

--18. Простая инструкция UPDATE
update treatment
set cost = cost * 0.9
where id_treatment = 1

--19. Инструкция UPDATE со скалярным подзапросом в предложении SET
update treatment
set cost = 
(
	SELECT MIN(cost)
	FROM treatment
)
where id_treatment = 3

--20. Простая инструкция DELETE
delete from animals
where animal_name is null

--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
delete from animals
where id in
(
	select id
	from animals
	where age = 1
)

--22. Инструкция SELECT, использующая обобщенное табличное выражение
with one (kind, animal_name) as
(
	select animals.kind, animals.animal_name
	from animals
)
select * from one

--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
drop table if exists testTable;
create table testTable
(
	UserID INT not null,
	Post VARCHAR(50),
	ManagerID INT
);
insert into testTable values
(1, 'Директор', NULL),
(2, 'Главный бухгалтер', 1),
(3, 'Бухгалтер', 2),
(4, 'Начальник отдела продаж', 1);

with recursive TestCTE(UserID, Post, ManagerID, LevelUser) as
   (    
        -- Находим якорь рекурсии
        select UserID, Post, ManagerID, 0 as LevelUser 
        from TestTable where ManagerID is null
        union all
        --Делаем объединение с TestCTE (хотя мы его еще не дописали)
        select t1.UserID, t1.Post, t1.ManagerID, t2.LevelUser + 1 
        from TestTable t1 join TestCTE t2 on t1.ManagerID=t2.UserID
   )
select * from TestCTE order by LevelUser

--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
--Сравнить цену стоимости с минимальной ценой из этой длительности лечения
select id_treatment, name, duration, cost, min(cost) over (partition by duration) as sum
from treatment
order by duration, cost;

--25. Оконные функции для устранения дублей
drop table if exists dupl_test;
create table dupl_test
(
	id INTEGER,
	name VARCHAR,
	location VARCHAR
);

insert into dupl_test(id, name, location) values
(0, 'Арчи', 'дом'),
(1, 'Буч', 'улица'),
(2, 'Арчи', 'дом'),
(3, 'Патрик', 'улица');

delete from dupl_test *
where id in (select id
			from (select id, row_number () over (partition by name, location order by name, location) rown
				  from dupl_test) t
			where t.rown > 1);

select * from dupl_test;

--допонительный
drop table if exists table1;
drop table if exists table2;
create table table1
(
	id INT NOT NULL,
	var1 VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm DATE
);

create table table2
(
	id INT NOT NULL,
	var2 VARCHAR(10),
	valid_from_dttm DATE,
	valid_to_dttm DATE
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-15'),
		(1, 'B', '2018-09-16', '5999-12-31');
		
INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-18'),
		(1, 'B', '2018-09-19', '5999-12-31');

SELECT t1.id, t1.var1, t2.var2, 
		GREATEST(t1.valid_from_dttm, t2.valid_from_dttm) as valid_from_dttm,
		LEAST(t1.valid_to_dttm, t2.valid_to_dttm) as valid_to_dttm
FROM table1 as t1, table2 as t2
WHERE t1.id = t2.id AND t1.valid_from_dttm <= t2.valid_to_dttm
		AND t2.valid_from_dttm <= t1.valid_to_dttm
