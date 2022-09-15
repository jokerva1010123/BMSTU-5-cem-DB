-- 4 вариант

DROP TABLE IF EXISTS workers CASCADE;
DROP TABLE IF EXISTS timetable CASCADE;

CREATE TABLE IF NOT EXISTS workers
(
    id INT PRIMARY KEY,
    fio VARCHAR,
    birthdate DATE,
    department VARCHAR
);

CREATE TABLE IF NOT EXISTS timetable
(
    worker_id INT,
    dt DATE,
    weekday VARCHAR,
    time_value time,
    action_type INT,
    FOREIGN KEY(worker_id) REFERENCES workers(id)
);

INSERT INTO workers
VALUES
    (1, 'fio1', '2001-09-09', 'depart1'),
    (2, 'fio2', '2001-03-23', 'depart2'),
    (3, 'fio3', '2001-01-18', 'bookkeeping'),
    (4, 'fio4', '2001-06-21', 'depart4'),
    (5, 'fio5', '2001-03-24', 'bookkeeping'),
    (6, 'fio6', '2001-02-14', 'bookkeeping'),
    (7, 'fio7', '2001-06-15', 'depart1');

INSERT INTO timetable
VALUES
    (1, '2021-12-01', 'Monday', '9:03', 1),
    (1, '2021-12-01', 'Monday', '10:30', 2),
    (1, '2021-12-09', 'Saturday', '11:50', 1),
    (1, '2021-12-09', 'Saturday', '19:30', 2),
    (1, '2021-12-25', 'Friday', '11:20', 1),
    (1, '2021-12-25', 'Friday', '18:45', 2),

    (2, '2021-12-01', 'Monday', '9:04', 1),
    (2, '2021-12-01', 'Monday', '17:30', 2),
    (2, '2021-12-09', 'Saturday', '11:50', 1),
    (2, '2021-12-09', 'Saturday', '19:30', 2),
    (2, '2021-12-25', 'Friday', '11:20', 1),
    (2, '2021-12-25', 'Friday', '18:45', 2),

    (3, '2021-12-01', 'Monday', '9:20', 1),
    (3, '2021-12-01', 'Monday', '10:30', 2),
    (3, '2021-12-09', 'Saturday', '12:50', 1),
    (3, '2021-12-09', 'Saturday', '19:30', 2),
    (3, '2021-12-25', 'Friday', '11:20', 1),
    (3, '2021-12-25', 'Friday', '18:45', 2),

    (4, '2021-12-01', 'Monday', '9:20', 1),
    (4, '2021-12-01', 'Monday', '10:30', 2),
    (4, '2021-12-09', 'Saturday', '15:50', 1),
    (4, '2021-12-09', 'Saturday', '19:30', 2),
    (4, '2021-12-25', 'Friday', '11:20', 1),
    (4, '2021-12-25', 'Friday', '18:45', 2),

    (6, '2021-12-25', 'Friday', '7:30', 1),
    (6, '2021-12-25', 'Friday', '18:45', 2),

    (5, '2021-12-25', 'Friday', '7:45', 1),
    (5, '2021-12-25', 'Friday', '18:45', 2);

CREATE OR REPLACE FUNCTION get_latecomers(today DATE)
RETURNS TABLE (fio VARCHAR, department VARCHAR) AS
$$
BEGIN
    RETURN QUERY
    SELECT workers.fio, workers.department
    FROM workers
    WHERE workers.fio NOT IN (SELECT DISTINCT w.fio
                              FROM workers AS w JOIN timetable AS t ON w.id = t.worker_id
                              WHERE t.dt = today AND t.action_type = 1);
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM get_latecomers('2021-12-09');