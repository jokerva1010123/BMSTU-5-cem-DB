create schema extra;

create table extra.table1(
	id int not null,
	var1 text,
	valid_from_dttm date not null,
	valid_to_dttm date not null
);

create table extra.table2(
	id int not null,
	var2 text,
	valid_from_dttm date not null,
	valid_to_dttm date not null
);

copy extra.table1 (id, var1, valid_from_dttm, valid_to_dttm) from 'C:/Program Files/PostgreSQL/13/table1.csv'
	with delimiter ',';
	
copy extra.table2 (id, var2, valid_from_dttm, valid_to_dttm) from 'C:/Program Files/PostgreSQL/13/table2.csv'
	with delimiter ',';
	
select *
from extra.table1 t 

select *
from extra.table2 t 

select *
from extra.table1 t1 join extra.table2 t2 on t1.id = t2.id

select t1.id, var1, var2, 
case
	when t1.valid_from_dttm > t2.valid_from_dttm then t1.valid_from_dttm 
	else t2.valid_from_dttm 
end as valid_from_dttm, 
case 
	when t1.valid_to_dttm < t2.valid_to_dttm then t1.valid_to_dttm 
	else t2.valid_to_dttm 
end as valid_to_dttm 
from extra.table1 t1 join extra.table2 t2 on t1.id = t2.id
where t1.id = t2.id and t1.valid_to_dttm > t2.valid_from_dttm 