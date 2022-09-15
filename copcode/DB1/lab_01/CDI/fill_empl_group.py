from psycopg2 import *
from psycopg2 import sql

conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')

with conn.cursor() as cursor:
    conn.autocommit = True
    j = 1
    for i in range(1, 201):
        values = [(i, j)]
        insert = sql.SQL('INSERT INTO employee_group (id_employee, id_group) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
        if i % 2 == 0:
            j += 1
cursor.close()
conn.close()