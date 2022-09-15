drop table if exists numbers;

create table numbers (number int);

insert into numbers values (-1), (2), (-3), (4), (-5), (0), (-7);

with recursive r as (
	select
		0 as i,
		1 as product

	union

	select
		i + 1 as i,
		product * (
			select number
			from numbers
			offset i limit 1
		) as product
	from r

	where i < (select count (*) from numbers)
)
select * from r;

drop table numbers;
