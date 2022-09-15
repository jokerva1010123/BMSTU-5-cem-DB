CREATE TABLE if not exists wines
(
    id         SERIAL       PRIMARY KEY,
    color      VARCHAR(5),
    sugar      VARCHAR(10),
    sort       VARCHAR(40),
    acidity    FLOAT,
    aging      INTEGER,
    volume     FLOAT
);


CREATE TABLE if not exists customers
(
    id              SERIAL         PRIMARY KEY,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    age             INTEGER,
    card            BOOLEAN,
    bonuses         INTEGER
);


CREATE TABLE if not exists manufactures
(
    id           SERIAL         PRIMARY KEY,
    name         VARCHAR(100)   UNIQUE,
    country      VARCHAR(40),
    experience   INTEGER,
    price        INTEGER,
    rating       INTEGER
);


CREATE TABLE if not exists sales
(
    id              SERIAL    PRIMARY KEY,
    wine_id         SERIAL,
    manufacture_id  SERIAL,
    customer_id     SERIAL,
    price           INTEGER,
    profit          INTEGER
);
