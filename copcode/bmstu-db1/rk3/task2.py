# 4 вариант

from peewee import *

connect = PostgresqlDatabase(
    database="rk3",
    user="regina",
    password="postgres",
    host="127.0.0.1",
    port=5432
)


class BaseModel(Model):
    class Meta:
        database = connect


class Workers(BaseModel):
    id = IntegerField(column_name='id')
    fio = CharField(column_name='fio')
    birthdate = DateField(column_name='birthdate')
    department = CharField(column_name='department')

    class Meta:
         table_name = 'workers'


class Timetable(BaseModel):
    worker_id = ForeignKeyField(Workers, backref="worker_id", on_delete="cascade")
    dt = DateField(column_name='dt')
    weekday = CharField(column_name='weekday')
    time_value = TimeField(column_name='time_value')
    action_type = IntegerField(column_name='action_type')

    class Meta:
         table_name = 'timetable'


# Найти сотрудников, опоздавших сегодня менее, чем на 5 минут
def task1():

    # SQL
    query_sql = connect.execute_sql(" \
        SELECT DISTINCT w.id, w.fio \
        FROM timetable AS t JOIN workers AS w ON  w.id = t.worker_id\
        WHERE t.dt = '2021-12-01' AND t.action_type = 1 AND (t.time_value - '09:00:00' < '00:05:00')\
        ")

    for worker in query_sql.fetchall():
        print(worker)

    # Python
    query = Workers.select(Workers.id, Workers.fio).distinct().join(Timetable).where(
        Timetable.dt == '2021-12-01',
        Timetable.action_type == 1,
        Timetable.time_value - '09:00:00' < '00:05:00'
        )

    for worker in query.dicts():
        print(worker)

#Найти сотрудников, которые выходили больше чем на 10 минут
def task2():

    # SQL
    query_sql = connect.execute_sql(" \
        SELECT DISTINCT w.id, w.fio\
        FROM timetable AS t JOIN workers AS w ON  w.id = t.worker_id\
        WHERE t.action_type = 2 AND t.time_value  - LAG(t.time_value) OVER (PARTITION BY t.time_value) > 10 \
        ")

    for worker in query_sql.fetchall():
        print(worker)

    # Python
    query = Workers.select(Workers.id, Workers.fio).distinct().join(Timetable).where(
        Timetable.action_type == 2,
        Timetable.time_value - fn.Lag(Timetable.time_value).over(partition_by=[Timetable.time_value])
        )

    for worker in query.dicts():
        print(worker)

#Найти сотрудников бухгалтерии, приходящих на работу раньше 8:00
def task3():

    # SQL
    query_sql = connect.execute_sql(" \
        SELECT DISTINCT w.id, w.fio\
        FROM timetable AS t JOIN workers AS w ON  w.id = t.worker_id\
        WHERE t.action_type = 1 AND (t.time_value  < '08:00:00') AND w.department = 'bookkeeping' \
        ")

    for worker in query_sql.fetchall():
        print(worker)

    # Python
    query = Workers.select(Workers.id, Workers.fio).distinct().join(Timetable).where(
        Timetable.action_type == 1,
        Timetable.time_value < '08:00:00',
        Workers.department == 'bookkeeping'
        )

    for worker in query.dicts():
        print(worker)

def main():
    print("\nTASK 1")
    task1()

    print("\nTASK 2")
    task2()

    print("\nTASK 3")
    task3()


if __name__ == "__main__":
    main()
    