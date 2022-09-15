-- DML триггер AFTER для логирования

DROP TABLE IF EXISTS logs;

CREATE TABLE logs
(
    id SERIAL PRIMARY KEY,
    msg VARCHAR
);

CREATE OR REPLACE FUNCTION write_to_log()
RETURNS TRIGGER AS
$$
DECLARE
    cur_msg VARCHAR(100);

BEGIN
    IF TG_OP = 'INSERT' THEN
        cur_msg = 'ADD: ' || NEW.sort || ' ' || NEW.color;
        INSERT INTO logs (msg) VALUES (cur_msg);
        RETURN NEW;
    ELSEIF TG_OP = 'UPDATE' THEN
        cur_msg = 'UPDATE: ' || NEW.sort || ' ' || NEW.color;
        INSERT INTO logs (msg) VALUES (cur_msg);
        RETURN NEW;
    ELSEIF TG_OP = 'DELETE' THEN
        cur_msg = 'DELETE: ' || OLD.sort || ' ' || OLD.color;
        INSERT INTO logs (msg) VALUES (cur_msg);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_trigger
AFTER INSERT OR UPDATE OR DELETE ON wines
FOR EACH ROW
EXECUTE PROCEDURE write_to_log();

INSERT INTO wines (color, sugar, sort, acidity, aging, volume)
VALUES ('red', 'sweet', 'Lambrusco', 5.5, 10, 25);

UPDATE wines
SET color = 'pink'
WHERE id = 1002;

DELETE FROM wines
WHERE id = 1002;

SELECT *
FROM logs;

SELECT *
FROM wines;
