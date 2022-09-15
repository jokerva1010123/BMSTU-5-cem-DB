from psycopg2 import *
from psycopg2 import sql
import mimesis as mem
import random as rand

pers = mem.Person('ru')
conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')
prop = [mem.enums.Gender.MALE, mem.enums.Gender.FEMALE]
gender = ['муж', 'жен']

with conn.cursor() as cursor:
    conn.autocommit = True
    for _ in range(1000):
        who = rand.randint(0, 1)
        values = [(pers.full_name(prop[who]), pers.telephone(), gender[who], mem.Address('ru').address())]
        insert = sql.SQL('INSERT INTO parent (full_name, phone, gender, address) VALUES {}').format(
            sql.SQL(',').join(map(sql.Literal, values)))
        cursor.execute(insert)
cursor.close()
conn.close()
