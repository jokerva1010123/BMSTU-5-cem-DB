use SHOP_GAMES
go

-- auto
select top 1 clid, clname, clsurname, clphone, clage
from client
for xml auto , elements

-- raw
select top 1 clid, clname, clsurname, clphone, clage
from client
for xml raw, elements

-- path
select top 1 clid, clname, clsurname, clphone, clage
from client
where clage < 30
for xml path('Client'), elements

-- explicit
select top 1 1 as Tag,
	null as Parent,
	clname as 'cl!1!name', 
	clsurname as 'cl!1!surname'
from client
for xml explicit


-- openxml
declare @idoc int
declare @doc xml
set @doc = '
<ROOT>
<Client>
	<clid>181</clid>
	<clname>sleep</clname>
	<clsurname>man</clsurname>
	<clphone>12345678912</clphone>
	<clage>50</clage>
</Client>
<Client>
	<clid>182</clid>
	<clname>tired</clname>
	<clsurname>man</clsurname>
	<clphone>12345678912</clphone>
	<clage>100</clage>
</Client>
</ROOT>'
exec sp_xml_preparedocument @idoc output, @doc
select *
from openxml (@idoc, N'/ROOT/Client', 2)
with (clid int, clname nvarchar(20), clsurname nvarchar(20), clphone nvarchar(11), clage int)

exec sp_xml_removedocument @idoc


-- openrowset
declare @idoc int
declare @doc xml
select @doc = c from openrowset (bulk 'C:\Users\mhita\Desktop\db\lab5\file.xml', single_blob) as temp(c)
exec sp_xml_preparedocument @idoc output, @doc
select *
from openxml (@idoc, N'/ROOT/Client', 2)
with (clid int, clname nvarchar(20), clsurname nvarchar(20), clphone nvarchar(11), clage int)

exec sp_xml_removedocument @idoc
