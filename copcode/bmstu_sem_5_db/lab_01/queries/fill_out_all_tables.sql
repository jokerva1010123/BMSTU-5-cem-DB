--DROP TABLE animals;
--DROP TABLE veterinarian CASCADE;
--DROP TABLE diagnosis CASCADE;
--DROP TABLE treatment CASCADE;


COPY veterinarian FROM 'C:\Program Files\PostgreSQL\13\database_csv\veterinarians.csv' DELIMITER ',' CSV;
COPY treatment FROM 'C:\Program Files\PostgreSQL\13\database_csv\treatments.csv' DELIMITER ',' CSV;
COPY diagnosis FROM 'C:\Program Files\PostgreSQL\13\database_csv\diagnosises.csv' DELIMITER ',' CSV;
COPY animals FROM 'C:\Program Files\PostgreSQL\13\database_csv\animals.csv' DELIMITER ',' CSV;