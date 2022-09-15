create database extra3

create table numbers (
	num real
)

drop table numbers

insert into numbers (
	num
)
values
	(1),
	(-0.2), 
	(+3.4)

-- таблица с единственным столбцом - число (любое - целое, веществ, отрицат, положит), посчитать их произведение
with dop as (
	select sum(case when num < 0 then 1 else 0 end)as neg_num,
		sum(case when num = 0 then 1 else 0 end) as zero_num
	from numbers
)
select case when zero_num <> 0 then 0
	when neg_num % 2 <> 0 then -1 * (select exp(sum(ln(abs(num)))) from numbers)
	else (select exp(sum(ln(abs(num)))) from numbers) end
from dop

select exp(sum(ln(abs(num))))
from numbers
