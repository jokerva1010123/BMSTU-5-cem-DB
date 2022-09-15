-- Использование агрегатных функций

-- Посчитать суммарный доход.

SELECT SUM(S.profit) AS sum_profit
FROM sales AS S;
