COPY wines(color, sugar, sort, acidity, aging, volume)
FROM '/home/regina/bmstu/sem5/bmstu-db/sem5/lab_01/generator/data/wines.csv' delimiter '|';


COPY customers(first_name, last_name, age, card, bonuses)
FROM '/home/regina/bmstu/sem5/bmstu-db/sem5/lab_01/generator/data/customers.csv' delimiter '|';


COPY manufactures(name, country, experience, price, rating)
FROM '/home/regina/bmstu/sem5/bmstu-db/sem5/lab_01/generator/data/manufactures.csv' delimiter '|';
 

COPY sales(wine_id, manufacture_id, customer_id, price, profit)
FROM '/home/regina/bmstu/sem5/bmstu-db/sem5/lab_01/generator/data/sales.csv' delimiter '|';
