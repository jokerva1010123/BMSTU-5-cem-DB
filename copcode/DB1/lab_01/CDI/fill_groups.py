from psycopg2 import *
from psycopg2 import sql
import mimesis as mem
import random as rand

conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')
text = mem.Text('ru')
types = ['Младшая', 'Средняя', 'Старшая', 'Подготовительная']

with conn.cursor() as cursor:
    conn.autocommit = True
    for _ in range(100):
        values = [(text.word(), types[rand.randint(0, 3)])]
        insert = sql.SQL('INSERT INTO groupp (name, type) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()