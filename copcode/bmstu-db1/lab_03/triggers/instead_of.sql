-- DML триггер INSTEAD OF для проверки возраста покупателя

CREATE OR REPLACE FUNCTION check_insert()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.age > 21 THEN
		RAISE NOTICE 'Customer inserted.';
		INSERT INTO customers (first_name, last_name, age, card, bonuses)
		VALUES (NEW.first_name, NEW.last_name, NEW.age, NEW.card, NEW.bonuses);
		RETURN NEW;
	ELSE
        RAISE EXCEPTION 'Age must be between 18 and 122';
        RETURN NULL;
	END IF;
END;
$$ LANGUAGE plpgsql;

DROP VIEW customers_view;
CREATE VIEW customers_view AS
SELECT * FROM customers LIMIT 2000;

CREATE TRIGGER check_trigger
INSTEAD OF INSERT ON customers_view
FOR EACH ROW
EXECUTE PROCEDURE check_insert();

INSERT INTO customers_view (first_name, last_name, age, card, bonuses)
VALUES ('Ivan', 'Cvetkov', 18, FALSE, 0);

INSERT INTO customers_view (first_name, last_name, age, card, bonuses)
VALUES ('Kirill', 'Kovalets', 23, TRUE, 10000);

SELECT *
FROM customers;

