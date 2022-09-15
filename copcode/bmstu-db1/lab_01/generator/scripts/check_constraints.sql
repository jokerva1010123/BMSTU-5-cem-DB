ALTER TABLE wines
    ALTER color SET NOT NULL,
    ALTER sugar SET NOT NULL,
    ALTER sort SET NOT NULL,
    ALTER acidity SET NOT NULL,
    ALTER aging SET NOT NULL,
    ADD CONSTRAINT check_color 
    CHECK ( color IN ('red', 'white', 'pink') ),
    ADD CONSTRAINT check_sugar
    CHECK ( sugar IN ('dry', 'semi-dry', 'semi-sweet', 'sweet') ),
    ADD CONSTRAINT check_sort
    CHECK ( sort != '' ),
    ADD CONSTRAINT check_acidity
    CHECK ( acidity >= 2.5 AND acidity <= 5.5 ),
    ADD CONSTRAINT check_aging
    CHECK ( aging >= 3 AND aging <= 100 ),
    ADD CONSTRAINT check_volume
    CHECK ( acidity >= 0.75 AND acidity <= 30 );


ALTER TABLE customers
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


ALTER TABLE manufactures
    ALTER name SET NOT NULL,
    ALTER country SET NOT NULL,
    ALTER experience SET NOT NULL,
    ALTER price SET NOT NULL,
    ALTER rating SET NOT NULL,
    ADD CONSTRAINT check_name_and_country
    CHECK ( name != '' AND country != '' ),
    ADD CONSTRAINT check_experience
    CHECK ( experience >= 1 AND experience <= 350 ),
    ADD CONSTRAINT check_delivery_price
    CHECK ( price >= 400 AND price <= 5000 ),
    ADD CONSTRAINT check_rating
    CHECK ( rating >= 0 AND rating <= 10 );


ALTER TABLE sales
    ADD FOREIGN KEY (wine_id) REFERENCES wines(id),
    ADD FOREIGN KEY (manufacture_id) REFERENCES manufactures(id),
    ADD FOREIGN KEY (customer_id) REFERENCES customers(id),
    ALTER price SET NOT NULL,
    ALTER profit SET NOT NULL,
    ADD CONSTRAINT check_selling_price
    CHECK ( price >= 480 AND price <= 6000 ),
    ADD CONSTRAINT check_profit
    CHECK ( profit >= 80 AND profit <= 1000 );
