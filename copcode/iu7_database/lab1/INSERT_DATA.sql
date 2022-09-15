BULK INSERT SHOP_GAMES.dbo.Client
FROM '/maindir/lab1/client_table.txt'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT SHOP_GAMES.dbo.Developer
FROM '/maindir/lab1/developer_table.txt'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT SHOP_GAMES.dbo.Platform
FROM '/maindir/lab1/platform_table.txt'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 

BULK INSERT SHOP_GAMES.dbo.Game
FROM '/maindir/lab1/game_table.txt'
WITH (DATAFILETYPE = 'char', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO 