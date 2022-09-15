-- Получить информацию о вине и его поставщике, если его сорт = '%Blanc%'

SELECT M.name, WS.color, WS.sort, WS.price
FROM manufactures AS M JOIN 
     (sales AS S JOIN wines AS W ON S.wine_id = W.id) AS WS 
     ON M.id = WS.manufacture_id
WHERE WS.sort LIKE '%Blanc%';
