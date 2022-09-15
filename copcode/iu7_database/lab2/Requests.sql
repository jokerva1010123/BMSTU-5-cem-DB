--1. Инструкция SELECT, использующая предикат сравнения
--Вывести клиентов старше 30 лет и упорядочить их по убыванию возраста
SELECT ClName, ClAge
FROM Client
WHERE ClAge > 30
ORDER BY ClAge DESC

--2. Инструкция SELECT, использующая предикат BETWEEN
--Вывести игры, которые вышли в период 2016-2019
SELECT GTitle, GYear
FROM Game
WHERE GYear BETWEEN 2016 AND 2019
ORDER BY GYear DESC

--3. Инструкция SELECT, использующая предикат LIKE
--Вывести имена клиентов, чей номер начинается на '8916'
SELECT ClName, ClPhone
FROM Client
WHERE ClPhone LIKE '8916%'

--4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом
--Вывести названия игр, разработчик которой находится в Японии
SELECT GId, GTitle, DevId
FROM Game
WHERE DevId IN (
    SELECT DevId
    FROM Developer
    WHERE DevCountry = 'Japan'
)

--5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
--Вывести имена клиентов, которые не купили игры
SELECT DISTINCT ClId, ClName, ClSurname
FROM Client
WHERE NOT EXISTS (
    SELECT Game.ClId
    FROM Game
    WHERE Client.ClId = Game.ClId
)

--6. Инструкция SELECT, использующая предикат сравнения с квантором
--Вывести список игр, год которых больше любого года игры с жанром Role-playing
SELECT GId, GTitle, GYear, GGenre
FROM Game
WHERE GYear > ALL (
    SELECT GYear
    FROM Game
    WHERE GGenre = 'Role-playing'
)

--7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
--Вывести среднюю, минимальную и максимульную цену игр жанра Action
SELECT AVG(GPrice) AS 'Price AVG (Action)', MIN(GPrice) AS 'Price MIN (Action)', MAX(GPrice) AS 'Price MAX (Action)'
FROM Game
WHERE GGenre = 'Action'

--8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов
--Вывести количество игр каждого клиетна
SELECT ClName, ClSurname, (
    SELECT COUNT(GTitle)
    FROM Game
    WHERE ClId = Client.ClId
) AS 'Number of game'
FROM Client

--9. Инструкция SELECT, использующая простое выражение CASE
--Вывести упрощенные названия жанров
SELECT GTitle,
    CASE GGenre
        WHEN 'Action' THEN 'AC'
        WHEN 'Adventure' THEN 'AD'
        WHEN 'Fighting' THEN 'F'
        WHEN 'Platform' THEN 'PL'
        WHEN 'Puzzle' THEN 'PU'
        WHEN 'Racing' THEN 'RA'
        WHEN 'Role-playing' THEN 'RP'
        WHEN 'Shooter' THEN 'SH'
        WHEN 'Simulation' THEN 'SI'
        WHEN 'Sports' THEN 'SP'
        WHEN 'Strategy' THEN 'ST'
    END AS GGenre
FROM Game

--10. Инструкция SELECT, использующая поисковое выражение CASE
--Вывести соответствующее сообщение, если цена игры больше/меньше/равна 3000
SELECT GId, GTitle, GPrice,
    CASE
        WHEN GPrice > 3000 THEN 'More than average'
        WHEN GPrice < 3000 THEN 'Less than average'
        ELSE 'Average value'
    END AS 'Average'
FROM Game

--11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
--Записать во временную таблицу платформы, год изготовления которых > 2015
DROP TABLE #Platfotm_tmp
SELECT PlId, PlTitle, PlYear
INTO #Platfotm_tmp
FROM Platform
WHERE PlYear > 2015

SELECT * FROM #Platfotm_tmp

--12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM
--Вывести клиентов по цене их игр
SELECT Client.ClName, Client.ClSurname, C.Price
FROM (
    SELECT Client.ClId, SUM(GPrice) AS Price
    FROM Game JOIN Client ON Game.ClId = Client.ClId
    GROUP BY Client.ClId
) AS C JOIN Client ON Client.ClId = C.ClId
 

--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
--Вывести клиента у которого сумма игр самая большая
SELECT Client.ClId, Client.ClName, Client.ClSurname
FROM Client
WHERE ClId = (
    SELECT ClId
    FROM Game
    GROUP BY ClId
    HAVING SUM(GPrice) = (
        SELECT MAX(Price)
        FROM (
            SELECT SUM(GPrice) AS Price
            FROM Game
            GROUP BY ClId
        ) AS C
    )  
)

--14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
--Вывести количество разработчиков в каждой стране
SELECT COUNT(DevId) AS [Count developers], DevCountry
FROM Developer
GROUP BY DevCountry

--15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING
--Вывести количество разработчиков в каждой стране, Если в стране больше 10 разработчиков
SELECT COUNT(DevId) AS [Count developers], DevCountry
FROM Developer
GROUP BY DevCountry
HAVING COUNT(DevId) > 10

--16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
--Добавить в таблицу нового клиента
INSERT Client (ClId, ClName, ClSurname, ClPhone, ClAge) VALUES (121, 'Sleepy', 'Man', '89250170813', 20)

--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
INSERT Developer (DevId, DevTitle, DevCountry)
SELECT PlId+200, (
    SELECT GTitle
    FROM Game
    WHERE GId = PlId
), 'Japan'
FROM Platform
WHERE PlDeveloper = 'Sony Interactive Entertainment'

--18. Простая инструкция UPDATE
UPDATE Game
SET GPrice = GPrice*2
WHERE GId = 10

--19. Инструкция UPDATE со скалярным подзапросом в предложении SET
--Меняет цену платформы на год ее выпуска, если PlId = 11
UPDATE Game
SET GPrice = (
    SELECT PlYear
    FROM Platform
    WHERE PlId = 11
)
WHERE PlId = 11

SELECT * FROM Game

--20. Простая инструкция DELETE
--КАК УДАЛИТЬ СТРОКУ С ВНЕШНИМ КЛЮЧОМ
DELETE Game
WHERE GTitle = 'Starfield'

--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
--Удаляются игры, разработчики которых из Австрии
DELETE FROM Game
WHERE ClId IN (
    SELECT Developer.DevId
    FROM Game JOIN Developer ON Game.DevId = Developer.DevId
    WHERE DevCountry = 'Austria'
)

SELECT * FROM Game ORDER BY DevId



--22. Инструкция SELECT, использующая простое обобщенное табличное выражение
--Вывести клиентов старше 30 с жанром Strategy
WITH CTE (ClId, ClName, ClSurname, ClAge, GGenre)
AS (
    SELECT Client.ClId, Client.ClName, ClSurname, Client.ClAge, Game.GGenre
    FROM Client JOIN Game ON Client.ClId = Game. ClId
    WHERE Client.ClAge > 30 AND Game.GGenre = 'Strategy'
)
SELECT ClId, ClName, ClSurname, ClAge, GGenre
FROM CTE
ORDER BY ClId 

-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
WITH Write(DevTitle, DevCountry, LEVEL) AS (
    SELECT D.DevTitle, D.DevCountry, 1 AS LEVEL
    FROM Developer AS D
    WHERE DevId = 1
    UNION ALL

    SELECT D.DevTitle, D.DevCountry, LEVEL+1
    FROM Developer AS D INNER JOIN Write AS W ON D.DevId = W.LEVEL+1
) 
SELECT * FROM Write;


-- --24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
SELECT GId, GPrice, GTitle, GGenre,
AVG(GPrice) OVER(PARTITION BY GGenre) AS AvgPrice,
MIN(GPrice) OVER(PARTITION BY GGenre) AS MinPrice,
MAX(GPrice) OVER(PARTITION BY GGenre) AS MaxPrice
FROM Game

--25. Оконные функции для устранения дублей
SELECT GGenre 
FROM (
    SELECT ROW_NUMBER()  OVER(PARTITION BY GGenre ORDER BY GGenre) AS n, GGenre
    FROM Game
) AS C
WHERE n = 1

