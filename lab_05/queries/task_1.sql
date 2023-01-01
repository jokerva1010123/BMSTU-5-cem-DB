/*
    1. Из таблиц базы данных, созданной в первой лабораторной работе,
    извлечь данные в XML (MSSQL) или JSON(Oracle, Postgres).
    Для выгрузки в XML проверить все режимы конструкции FOR XML
*/

--копировать надо в папку общего доступа (например, каталог диска С)
COPY (select row_to_json(animals) from animals) TO 'C:\data_lab_05\animals.json';
COPY (select row_to_json(veterinarians) from veterinarians) TO 'C:\data_lab_05\veterinarians.json';
COPY (select row_to_json(diagnoses) from diagnoses) TO 'C:\data_lab_05\diagnoses.json';
COPY (select row_to_json(treatments) from treatments) TO 'C:\data_lab_05\treatments.json';