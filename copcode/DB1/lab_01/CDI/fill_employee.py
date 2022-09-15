from psycopg2 import *
from psycopg2 import sql
import datetime as dt
import mimesis as mem
import random as rand

pers = mem.Person('ru')
conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')
prop = [mem.enums.Gender.MALE, mem.enums.Gender.FEMALE]
gender = ['муж', 'жен']
edu = ['Московский городской педагогический университет', 'Московский институт психоанализа',
       'Московский государственный гуманитарно-экономический университет', 'Российский университет кооперации']

with conn.cursor() as cursor:
    conn.autocommit = True
    for _ in range(200):
        who = rand.randint(0, 1)
        y = rand.randint(1950, 2000)
        m = rand.randint(1, 12)
        d = rand.randint(1, 28)
        fk = rand.randint(1, 15)
        exp = rand.randint(100, (2020 - y - 18) * 365)
        values = [(fk, pers.full_name(prop[who]), 'Воспитатель', dt.date(y, m, d), gender[who], pers.telephone(),
                   dt.timedelta(days=exp), edu[rand.randint(0, 3)])]
        insert = sql.SQL('INSERT INTO employee (id_institution, full_name, func, dob, gender, phone, experience, '
                         'education) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()