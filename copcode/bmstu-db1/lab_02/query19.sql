-- Update со скалярным подзапросом в предложении SET.

-- У первого в таблице вина поменять выдержку
-- на максимальную выдержку вин кислотностью 2.5

UPDATE wines
SET aging = (SELECT MAX(aging)
			 FROM wines
			 WHERE acidity = 2.5)
WHERE id = 1;
