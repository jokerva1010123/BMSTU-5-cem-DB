-- DELETE c вложенным коррелированным подзапросом

-- Удалить поставщиков из России с 10-летним опытом.

DELETE FROM manufactures
WHERE id IN (SELECT id
             FROM manufactures
             WHERE country = 'Russia' AND experience = 10);
