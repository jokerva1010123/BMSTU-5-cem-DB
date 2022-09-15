-- Update.

-- Дать 20-летним покупателям
-- бонусную карту.

UPDATE customers
SET card = TRUE
WHERE age = 20;
