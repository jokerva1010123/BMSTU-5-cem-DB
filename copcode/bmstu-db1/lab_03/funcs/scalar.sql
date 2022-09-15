-- Функция подсчета суммарного дохода.

CREATE OR REPLACE FUNCTION get_sum_profit() RETURNS INTEGER AS
'
DECLARE
sum_profit INTEGER;

BEGIN

SELECT SUM(profit)
FROM sales INTO sum_profit;

RETURN sum_profit;

END;
' LANGUAGE plpgsql;


SELECT get_sum_profit() AS sum_profit;
