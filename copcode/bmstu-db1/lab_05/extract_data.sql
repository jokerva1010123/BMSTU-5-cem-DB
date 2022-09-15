-- Извлечь данные из таблиц базы данных в JSON.

--psql -h localhost regina -d wine-sales

\o customers.json
SELECT row_to_json(c)
FROM customers AS c;

\o manufactures.json
SELECT row_to_json(m)
FROM manufactures AS m;

\o wines.json
SELECT row_to_json(w)
FROM wines AS w;

\o sales.json
SELECT row_to_json(s)
FROM sales AS s;
