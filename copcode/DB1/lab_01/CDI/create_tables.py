from psycopg2 import *

conn = connect(dbname='KinderGarden', user='postgres', password='1991055й', host='localhost')

with conn.cursor() as cursor:
    conn.autocommit = True
    sql_file = open('CDI/create_tables.sql', 'r')
    cursor.execute(sql_file.read())
cursor.close()
conn.close()