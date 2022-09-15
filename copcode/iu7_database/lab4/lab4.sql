use SHOP_GAMES
go

sp_configure 'show advanced options', 1 
GO 
RECONFIGURE 
GO 
sp_configure 'clr enabled', 1 
GO 
RECONFIGURE 
GO 
EXEC sp_configure 'clr strict security', 0; 
RECONFIGURE;

CREATE ASSEMBLY SqlServerUDF 
AUTHORIZATION dbo 
FROM '\users\mhita\source\repos\Database1\Database1\bin\Debug\Database1.dll' 
WITH PERMISSION_SET = SAFE 
GO 

drop function DifferenceNum
drop aggregate agg
drop function listofgame
drop procedure findnames
drop trigger SqlTrigger1 
drop table test
drop type polis
drop assembly sqlserverudf

go

-- скал€рна€ функци€
-- разность посылаемых чисел
CREATE FUNCTION DifferenceNum(@num1 INT, @num2 int) 
RETURNS INT 
AS 
EXTERNAL NAME 
SqlServerUDF.[SqlServerUDF].DifferenceNum
GO 

SELECT dbo.DifferenceNum(6, 5) AS Diff
GO



-- агрегатна€ функци€
-- объедин€ет строки
CREATE AGGREGATE Agg (@input nvarchar(200)) 
RETURNS nvarchar(max) 
EXTERNAL NAME 
SqlServerUDF.Concatenate;

SELECT GGenre, dbo.Agg(GTitle) as "string"
FROM game 
GROUP BY GGenre;


-- таблична€ функци€
-- список игр, вышедших после выбранного года

CREATE FUNCTION ListOfGame ( @year nvarchar(40) ) 
RETURNS TABLE 
( 
	gid int, 
	gyear INT 
) 
AS 
EXTERNAL NAME 
SqlServerUDF.[UserDefinedFunctions].ListOfGame
GO

select gid, gyear from dbo.ListOfGame(2020)


-- хранима€ процедура
-- выводит количество и средний возраст клиентов с заданным именем
create procedure FindNames(@name nvarchar(30)) 
as
external name
SqlServerUDF.[StoredProcedures].FindNames
go

exec FindNames "Kira"
go


-- триггер
-- год выхода платформы не может быть > 2020, insert

create trigger SqlTrigger1 
on dbo.Platform
for insert
as external name SqlServerUDF.[Triggers].SqlTrigger1

insert platform values(106, 'Sleep', 'Man', 2022)
insert platform values(108, 'Sleep', 'Man', 2020)


-- опередел€емый пользователем тип данных
-- сери€ и номер медицинского полиса

create type polis
external name SqlServerUDF.polis
go

create table dbo.test
(
	id int identity(1, 1) not null,
	p polis null
)

insert test values('770000 1234567891')
insert test values('999991 9999999919')
insert test values('77000012 34567891')
insert test values('7700 001234567891')
insert test values('770000 12345167891')