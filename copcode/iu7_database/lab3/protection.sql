use SHOP_GAMES
go

-- триггер который при создании новой таблицы выводилось в какой схеме, какая таблица и когда была создана

create TRIGGER t1
on database
after create_table
as 
begin
    select top 1 ao.create_date, ao.name, s.name
    from sys.all_objects as ao left join sys.schemas as s on ao.schema_id = s.schema_id
    where type = 'u'
    order by ao.create_date DESC

end

drop TRIGGER t1 on database