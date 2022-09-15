from psycopg2 import *
from psycopg2 import sql
import datetime as dt
import random as rand

conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')

with conn.cursor() as cursor:
    conn.autocommit = True
    for i in range(1, 1200):
        y = rand.randint(2014, 2019)
        m = rand.randint(1, 12)
        d = rand.randint(1, 28)
        inst = rand.randint(1, 15)
        train = rand.randint(365, 1900)
        cost = rand.uniform(1000, 5000) + (i / 100)
        values = [(inst, ((i - 1) % 1000) + 1, i, dt.datetime(y, m, d), dt.timedelta(days=train), cost)]
        insert = sql.SQL('INSERT INTO contract (id_institution, id_parent, id_child, date_of_conclusion, '
                         'training_period, service_cost) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()