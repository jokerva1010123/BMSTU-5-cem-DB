from psycopg2 import *
from psycopg2 import sql
import mimesis as mem
import random as rand

pers = mem.Person('ru')
conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')
text = mem.Text('ru')

with conn.cursor() as cursor:
    conn.autocommit = True
    for _ in range(15):
        values = [(text.word(), pers.telephone(), mem.Address('ru').address(), rand.randint(50, 150))]
        insert = sql.SQL('INSERT INTO institution (name, phone, address, max_num_of_seats) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()
