-- Предикат BETWEEN

-- Получить информацию о названии, стране и опыте
-- поставщиков с рейтингом от 5 до 10 включительно.

SELECT M.name, M.country, M.experience
FROM manufactures AS M
WHERE M.rating BETWEEN 5 AND 10;
