-- Предикат сравнения

-- Получить информацию о сорте и выдержке вина
-- белого цвета.

SELECT W.sort, W.aging
FROM wines AS W
WHERE W.color = 'white';
