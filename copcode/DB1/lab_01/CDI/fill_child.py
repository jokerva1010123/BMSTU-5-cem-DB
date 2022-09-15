from psycopg2 import *
from psycopg2 import sql
import datetime as dt
import mimesis as mem
import random as rand

pers = mem.Person('ru')
conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')
prop = [mem.enums.Gender.MALE, mem.enums.Gender.FEMALE]
gender = ['муж', 'жен']

with conn.cursor() as cursor:
    conn.autocommit = True
    for _ in range(1200):
        who = rand.randint(0, 1)
        y = rand.randint(2013, 2018)
        m = rand.randint(1, 12)
        d = rand.randint(1, 28)
        fk = rand.randint(1, 100)
        values = [(pers.full_name(prop[who]), dt.date(y, m, d), gender[who], fk)]
        insert = sql.SQL('INSERT INTO child (full_name, dob, gender, id_group) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()