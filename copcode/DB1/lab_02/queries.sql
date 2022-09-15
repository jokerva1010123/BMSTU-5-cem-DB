-- №1 Инструкция SELECT, использующая предикат сравнения.
-- Вывести ФИО, номер, пол у работников женщин.
select * from employee;

select full_name, phone, gender
from employee
where gender = 'жен';

-- №2 Инструкция SELECT, использующая предикат BETWEEN.
-- Вывести информацию о детях рождённых в 2018 году.
select * from child;

select full_name as "ФИО", dob as "Дата рождения", gender as "Пол"
from child
where dob between '2018-01-01' and '2018-12-31'
order by dob;

-- №3 Инструкция SELECT, использующая предикат LIKE.
-- Вывести информацию о работниках в названии вуза которых присутсвует слово "государсвенный".
select * from employee;

select full_name as "ФИО", phone as "Номер телефона", education as "Образование"
from employee
where education like '%государственный%'
order by full_name;

-- №4 Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
-- Вывести стоимость образования, ФИО ребёнка, год его рождения 
-- для детей, которые родились в 2017 году и имеют стоимость обучения > 2000

select * from contract;

select Co.service_cost, Ch.full_name, Ch.dob
from contract Co join child Ch on Co.id_child = Ch.id_child
where Ch.id_child in 
	(
		select id_child
		from child
		where dob >= '2017-01-01' and dob <= '2017-12-31'
	) and Co.service_cost > 2000
order by Ch.full_name;

-- №5 Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
-- Вывести информацию о детях время обучения которых меньше чем 500 дней.

select id_child as id, full_name as "ФИО" 
from child Ch
where exists 
	(
		select 1
		from contract Co
		where Ch.id_child = Co.id_child and Co.training_period < '500 days'
	);

-- №6 Инструкция SELECT, использующая предикат сравнения с квантором.
-- Вывести информацию о учреждениях где кол-во мест больше кол-ва мест у учреждений
-- номер телефона которых заканчивается на цифру 3
		
select * 
from institution
where max_num_of_seats > ALL
	(
		select max_num_of_seats
		from institution
		where phone like '%3'
	);

-- №7 Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
-- Вывести среднее кол-во мест по всем детским садам.

select AVG(max_num_of_seats) as "Среднее кол-во мест"
from institution;

-- №8 Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Вывести информацию об учреждении и средюю стоимость обучения в нём.

select name, phone, 
	(
		select AVG(service_cost)
		from contract Co
		where Co.id_institution = Ins.id_institution
	) as "Средняя стоимость обучения"
from institution Ins;

-- №9 Инструкция SELECT, использующая простое выражение CASE.
-- Вывести информацию о детях и определить дату их зачисления в детский сад

SELECT Ch.full_name, Ch.dob, Ch.gender,
	case extract(year from Co.date_of_conclusion)
		when extract(year from current_date) then 'В этом году'
		when extract(year from current_date) - 1 then 'В прошлом году'
		else 'Позже двух лет'
	end as "Дата зачисления"
from contract Co join child Ch on Co.id_child = Ch.id_child;



-- №10 Инструкция SELECT, использующая поисковое выражение CASE.
-- Вывести информацию о сотрудниках и столбец его опытности.

select full_name, dob, gender, 
	case 
		when experience > '3000 days' then 'Опытный'
		when experience <= '3000 days' then 'Неопытный'
	end as "Опыт"
from employee;

--№11 Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
-- Вывести информацию о родителе и стоимость которую ему необходимо заплатить

select P.full_name, P.phone, C.service_cost
into temp temp_bills
from contract C join parent P on C.id_parent = P.id_parent;

select * from temp_bills;

-- № 12 Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве 
-- производных таблиц в предложении FROM.
-- Вывести фио родителя и информацию о его ребёнке.

select P.full_name as "ФИО родителя", CC.full_name as "ФИО ребёнка", 
	CC.dob as "Дата рождения ребёнка", CC.gender as "Пол ребёнка"
from parent P join
	(
		select Co.id_parent, Ch.full_name, Ch.dob, Ch.gender
		from contract Co join child Ch on Co.id_child = Ch.id_child
	) as CC
on P.id_parent = CC.id_parent;

-- №13 Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
-- Вывести информацию об учреждениях в которых дети занимаются в группах с нужными названиями.

select *
from institution
where id_institution in
(
	select id_institution
	from contract
	where id_child in 
	(
		select id_child
		from child
		where id_group in 
		(
			select id_group
			from groupp
			where name in ('успех', 'солнце')
		)
	)
);

-- №14 Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, 
-- но без предложения HAVING.
-- Вывести кол-ва обучающихся детей по каждому типу группы.

select G.type as "Тип группы", count(*) as "Кол-во учащихся"
from child C join groupp G on C.id_group = G.id_group
group by G.type;

-- №15 Инструкция SELECT, консолидирующая данные с помощью предложения GROUPBY и предложения HAVING.
-- Получить список вузов работников учреждений средний опыт которых больше чем 3000 дней.

select education as "Образование", count(*) as "Кол-во сотрудников"
from employee
group by education
having AVG(experience) > '3000 days';

-- №16 Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.

insert into groupp(name, type)
values ('ромашка', 'Подготовительная');

select * from groupp;

-- №17 Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных
-- вложенного подзапроса.

insert into institution (name, phone, address, max_num_of_seats)
select 'вояки', phone, address, 100
from institution
where id_institution = 10;

select * from institution;

-- №18 Простая инструкция UPDATE.

update institution
set phone = '+7-(916)-119-01-30'
where name = 'Вояки';

select * from institution where name = 'вояки';

-- №19 Инструкция UPDATE со скалярным подзапросом в предложении SET.

update institution
set max_num_of_seats = 
	(
		select AVG(max_num_of_seats)
		from institution
	)
where name = 'вояки';

select * from institution where name = 'вояки';

-- №20 Простая инструкция DELETE.

delete from institution 
where name = 'вояки';

-- №21 Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
		
delete from institution 
where id_institution not in 
	(
		select Ins.id_institution
		from contract C join institution Ins on C.id_institution = Ins.id_institution
	);
	
select * from institution;

-- №22 Инструкция SELECT, использующая простое обобщенное табличное выражение

with CTE(fio, phone, address)
as
(
	select full_name, phone, address
	from parent
	where gender = 'муж'
)

select * from CTE;

-- №23 Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.

select * from contract;

WITH RECURSIVE rec_cte AS (
  	SELECT id_parent, id_child
	FROM contract
	WHERE id_parent = 1
	
    UNION ALL
	
  	SELECT C.id_parent, C.id_child 
	FROM rec_cte R JOIN contract C ON R.id_child + 1 = C.id_parent
) 
SELECT * 
FROM rec_cte;

-- №24 Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- Вывести информацию об учреждении и ср, мин, макс стоимость договоров в каждом.

select distinct Ins.name, Ins.phone,
	avg(C.service_cost) over (partition by C.id_institution) as "Средняя стоимость",
	min(C.service_cost) over (partition by C.id_institution) as "Минимальная стоимость",
	max(C.service_cost) over (partition by C.id_institution) as "Максимальная стоимость"
from contract C join institution Ins on C.id_institution = Ins.id_institution;

-- №25 Оконные фнкции для устранения дублей

select C.id_contract, Ins.name, Ins.phone,
	avg(C.service_cost) over (partition by C.id_institution) as avg_cost
into temp ins_avg_cost
from contract C join institution Ins on C.id_institution = Ins.id_institution;

select * from ins_avg_cost;

delete from ins_avg_cost
where id_contract in
(
	select id_contract from
	(
		select *, row_number() over(partition by name, phone, avg_cost) as unique_num
		from ins_avg_cost
	) as temp_table
	where temp_table.unique_num > 1
);

-- Дополнительное задание
-- Создать таблицы:
-- • Table1{id: integer, var1: string, valid_from_dttm: date, valid_to_dttm: date}
-- • Table2{id: integer, var2: string, valid_from_dttm: date, valid_to_dttm: date}
-- Версионность в таблицах непрерывная, разрывов нет (если valid_to_dttm = '2018-09-05', 
-- то для следующей строки соответсвующего ID valid_from_dttm = '2018-09-06', т.е. на день больше). 
-- Для каждого ID дата начала версионности и дата конца версионности в Table1 и Table2 совпадают.
-- Выполнить версионное соединение двух талиц по полю id.

create table if not exists Table1 
(
	id int not null,
	var1 varchar(50) not null,
	valid_from_dttm date not null,
	valid_to_dttm date not null
);

create table if not exists Table2 
(
	id int not null,
	var2 varchar(50) not null,
	valid_from_dttm date not null,
	valid_to_dttm date not null
);

insert into Table1 (id, var1, valid_from_dttm, valid_to_dttm) 
values (1, 'A', '2018-09-01', '2018-09-15'),
		(1, 'B', '2018-09-16', '5999-12-31');
insert into Table2 (id, var2, valid_from_dttm, valid_to_dttm) 
values (1, 'A', '2018-09-01', '2018-09-18'),
		(1, 'B', '2018-09-19', '5999-12-31');
		
select 1 as id, T1.var1, T2.var2, 
	case 
		when T1.valid_from_dttm < T2.valid_from_dttm then T2.valid_from_dttm
		else T1.valid_from_dttm
	end as valid_from_dttm, 
	
	case 
		when T1.valid_to_dttm > T2.valid_to_dttm then T2.valid_to_dttm
		else T1.valid_to_dttm 
	end as valid_to_dttm
from Table1 T1 join Table2 T2 on T1.valid_from_dttm < T2.valid_to_dttm 
							  and T1.valid_to_dttm > T2.valid_from_dttm;
