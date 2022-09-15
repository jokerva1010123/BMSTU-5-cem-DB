-- Создать двойника таблицы покупателей

CREATE TABLE if not exists double_customers
(
    id              SERIAL         PRIMARY KEY,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    age             INTEGER,
    card            BOOLEAN,
    bonuses         INTEGER
);

ALTER TABLE double_customers
    ALTER first_name SET NOT NULL,
    ALTER last_name SET NOT NULL,
    ALTER age SET NOT NULL,
    ALTER card SET NOT NULL,
    ALTER bonuses SET NOT NULL,
    ADD CONSTRAINT check_name
    CHECK ( first_name != '' AND last_name != '' ),
    ADD CONSTRAINT check_age
    CHECK ( age >= 18 AND age <= 122 ),
    ADD CONSTRAINT check_card
    CHECK ( card IN (TRUE, FALSE) ),
    ADD CONSTRAINT check_bonuses
    CHECK ( bonuses >= 0 AND bonuses <= 100000 );
