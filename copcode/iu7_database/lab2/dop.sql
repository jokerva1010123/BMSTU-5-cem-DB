use SHOP_GAMES
go

create table Table1 (
    id int, 
    var1 nvarchar(25),
    valid_from_dttm date, 
    valid_to_dttm date
);
go

create table Table2 (
    id int, 
    var2 nvarchar(25),
    valid_from_dttm date, 
    valid_to_dttm date
);
go

insert into Table1 values (1,'A','2018-09-01','2018-09-15')
insert into Table1 values (1,'B','2018-09-16','2018-09-30')
insert into Table2 values (1,'A','2018-09-01','2018-09-18')
insert into Table2 values (1,'B','2018-09-19','2018-09-30')
go

select * from Table1
select * from Table2
go

select * from (
    select T1.id as id, T1.var1 as var1, T2.var2 as var2,
        case
            when T1.valid_from_dttm > T2.valid_from_dttm then T1.valid_from_dttm
            else T2.valid_from_dttm 
        end as valid_from_dttm,
        case 
            when T1.valid_to_dttm < T2.valid_to_dttm then T1.valid_to_dttm
            else T2.valid_to_dttm
        end as valid_to_dttm
    from Table1 T1 JOIN Table2 T2 on T1.id = T2.id
) as Result
where valid_to_dttm >= valid_from_dttm

drop table Table1
drop table Table2
go