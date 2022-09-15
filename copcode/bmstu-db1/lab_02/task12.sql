-- SELECT *
-- FROM wines
-- WHERE sort = 'Cahors'

SELECT sort, SUM(volume)
FROM wines
GROUP BY sort
HAVING sort = 'Cahors'