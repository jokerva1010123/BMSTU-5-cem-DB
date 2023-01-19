create database rk_3
create table if not exists employee (
	id int not null primary key,
	fio varchar,
	birthdate date, 
	department varchar
);

create table if not exists record(
	employee_id int references employee(id) not null,
	rdate date,
	dayweek varchar,
	rtime time,
	rtype int
);

insert into employee(
	id,
	fio,
	birthdate, 
	department
) values 
	(1, 'FIO1', '1995-09-25', 'IT'),
	(2, 'FIO2', '1999-09-30', 'IT'),
	(3, 'FIO3', '1990-09-25', 'Fin'),
	(4, 'FIO4', '1997-09-15', 'Fin');


insert into employee(
	id,
	fio,
	birthdate, 
	department
) values 
	(5, 'FIO5', '1995-09-25', 'IT'),
	(6, 'FIO6', '1999-09-30', 'IT'),
	(7, 'FIO7', '1990-09-25', 'Fin'),
	(8, 'FIO8', '1997-09-15', 'Fin'),
	(9, 'FIO9', '1990-09-25', 'Fin'),
	(10, 'FIO10', '1991-09-25', 'Fin'),
	(11, 'FIO11', '1992-09-22', 'Fin'),
	(12, 'FIO12', '1993-09-26', 'Fin'),
	(13, 'FIO13', '1994-09-25', 'Fin'),
	(14, 'FIO14', '1995-09-15', 'Fin'),
	(15, 'FIO15', '1996-09-24', 'Fin'),
	(16, 'FIO16', '1996-09-22', 'Fin'),
	(17, 'FIO17', '1994-05-25', 'Fin'),
	(18, 'FIO18', '1997-04-25', 'Fin');


insert into record(
	employee_id, 
	rdate, 
	dayweek, 
	rtime, 
	rtype
) values
	(1, '2022-12-20', 'Понедельник', '09:01', 1),
	(1, '2022-12-20', 'Понедельник', '09:12', 2),
	(1, '2022-12-20', 'Понедельник', '09:40', 1),
	(1, '2022-12-20', 'Понедельник', '12:01', 2),
	(1, '2022-12-20', 'Понедельник', '13:40', 1),
	(1, '2022-12-20', 'Понедельник', '20:40', 2),
	
	(1, '2022-12-21', 'Понедельник', '09:01', 1),
	(1, '2022-12-21', 'Понедельник', '09:12', 2),
	(1, '2022-12-21', 'Понедельник', '09:40', 1),
	(1, '2022-12-21', 'Понедельник', '12:01', 2),
	(1, '2022-12-21', 'Понедельник', '13:40', 1),
	(1, '2022-12-21', 'Понедельник', '20:40', 2),
	
	(1, '2022-12-22', 'Понедельник', '09:01', 1),
	(1, '2022-12-22', 'Понедельник', '09:12', 2),
	(1, '2022-12-22', 'Понедельник', '09:40', 1),
	(1, '2022-12-22', 'Понедельник', '12:01', 2),
	(1, '2022-12-22', 'Понедельник', '13:40', 1),
	(1, '2022-12-22', 'Понедельник', '20:40', 2),
	
	
	(3, '2022-12-21', 'Понедельник', '09:01', 1),
	(3, '2022-12-21', 'Понедельник', '09:12', 2),
	(3, '2022-12-21', 'Понедельник', '09:40', 1),
	(3, '2022-12-21', 'Понедельник', '12:01', 2),
	(3, '2022-12-21', 'Понедельник', '13:40', 1),
	(3, '2022-12-21', 'Понедельник', '20:40', 2),

	(2, '2022-12-21', 'Понедельник', '08:51', 1),
	(2, '2022-12-21', 'Понедельник', '20:31', 2),

	(4, '2022-12-21', 'Понедельник', '07:51', 1),
	(4, '2022-12-21', 'Понедельник', '20:31', 2),
	
	(6, '2022-12-21', 'Понедельник', '09:51', 1),
	(6, '2022-12-21', 'Понедельник', '20:31', 2),

	(1, '2022-12-23', 'Среда', '09:11', 1),
	(1, '2022-12-23', 'Среда', '09:12', 2),
	(1, '2022-12-23', 'Среда', '09:40', 1),
	(1, '2022-12-23', 'Среда', '20:01', 2),

	(3, '2022-12-23', 'Среда', '09:01', 1),
	(3, '2022-12-23', 'Среда', '09:12', 2),
	(3, '2022-12-23', 'Среда', '09:50', 1),
	(3, '2022-12-23', 'Среда', '20:01', 2),

	(2, '2022-12-23', 'Среда', '08:41', 1),
	(2, '2022-12-23', 'Среда', '20:31', 2),

	(4, '2022-12-23', 'Среда', '09:51', 1),
	(4, '2022-12-23', 'Среда', '20:31', 2);

--function: return employee didn't come "today"
create or replace function not_work(d date)
returns table(_fio varchar, _depart varchar)
AS $$
BEGIN
 return query
 (   select fio, department from employee
     where fio not in(
        select employee.fio
        from employee join record on (employee.id = record.employee_id)
        where record.rdate = d
        group by fio)

 );
END
$$
language plpgsql;
SELECT * FROM not_work('2022-12-21');

-- TASK 2
--SQL

--Найти сотрудников, опоздавших сегодня меньше, чем на 5 минут
with first_time_in as (
 select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
 from record
 where rtype = 1)
select employee.id, employee.fio, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where rdate = '2022-12-21' and time_in <= '9:05' and time_in > '9:00';

--Найти сотрудников, которые выходили больше, чем на 10 минут
select DISTINCT employee_id
from employee join
 (
 select employee_id, rdate, rtime,
     rtype,
     lag(rtime) over (partition by employee_id, rdate order by rtime) as prev_time,
     rtime-lag(rtime) over (partition by employee_id, rdate order by rtime) as tmp_dur
  from record 
  order by employee_id, rdate, rtime
  ) as small_durations
on employee.id = small_durations.employee_id
where small_durations.rdate = '2022-12-21'
and small_durations.tmp_dur > '00:10:00'
group by small_durations.employee_id
HAVING count(small_durations.employee_id) > 1;

--Найти сотрудников бухгалтерии, приходивших на работу раньше 8:00       
with first_time_in as (
 select distinct on (rdate, time_in) employee_id, rdate, min(rtime) OVER (PARTITION BY employee_id, rdate) as time_in
 from record
 where rtype = 1)
select employee.id, employee.fio, time_in
from first_time_in join employee on first_time_in.employee_id = employee.id
where employee.department = 'Fin' and time_in <= '8:00';

