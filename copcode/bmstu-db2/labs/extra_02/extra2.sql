create extension plpython3u

CREATE database extra2

create table employee_status(
	department text not null,
	fio text not null,
	status_date date not null,
	status text not null
)

drop table employee_status 

insert into employee_status (
	department,
	fio,
	status_date,
	status
) 
values
	('ИТ', 'Иванов Иван Иванович', '2020-01-15', 'Больничный'),
	('ИТ', 'Иванов Иван Иванович', '2020-01-16', 'На работе'),
	('ИТ', 'Иванов Иван Иванович', '2020-01-17', 'На работе'),
	('ИТ', 'Иванов Иван Иванович', '2020-01-18', 'На работе'),
	('ИТ', 'Иванов Иван Иванович', '2020-01-19', 'Оплачиваемый отпуск'),
	('ИТ', 'Иванов Иван Иванович', '2020-01-20', 'Оплачиваемый отпуск'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-15', 'Оплачиваемый отпуск'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-16', 'На работе'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-17', 'На работе'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-18', 'На работе'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-19', 'Оплачиваемый отпуск'),
	('Бухгалтерия', 'Петрова Ирина Ивановна', '2020-01-20', 'Оплачиваемый отпуск')
	
select *
from employee_status

with full_status as (
	select department, fio, status_date, status,
		lag(status_date) over (partition by department, fio, status order by status_date) as date_before,
		lead(status_date) over (partition by department, fio, status order by status_date) as date_after,
		count(*) over (partition by department, fio, status order by status_date) as continue_days
	from employee_status
)
select fs1.department, fs1.fio, fs1.status_date as date_from, fs2.status_date as date_to, fs1.status
from full_status fs1 join full_status fs2 on fs1.department = fs2.department and fs1.fio = fs2.fio and fs1.status = fs2.status
where (fs1.date_before is null or fs1.status_date - fs1.date_before > 1) and 
	(fs2.date_after is null or fs2.date_after - fs2.status_date > 1) and 
	(fs2.status_date - fs1.status_date >= 0 and fs2.status_date - fs1.status_date <= fs2.continue_days)
