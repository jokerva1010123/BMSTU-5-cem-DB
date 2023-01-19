from peewee import *
from time import *
from datetime import *
con = PostgresqlDatabase(
 database = "rk_3",
 user = "postgres",
 password = "0612",
 host = "localhost",
 port = "5432"
 )
class BaseModel(Model):
 class Meta:
    database = con

class Employee(BaseModel):
 id = IntegerField(column_name='id')
 fio = CharField(column_name='fio')
 birthday = DateField(column_name='birthdate')
 depart = CharField(column_name='department')
 class Meta:
    table_name = 'employee'

class Record(BaseModel):
 id_emp = IntegerField(column_name='employee_id')
 rdate = DateField(column_name='rdate')
 wday = CharField(column_name='dayweek')
 rtime = TimeField(column_name='rtime')
 rtype = IntegerField(column_name='rtype')
 class Meta:
    table_name = 'record'
def print_query(query):
 u_b = query.dicts().execute()
 for elem in u_b:
    print(elem)

#Найти сотрудников, опоздавших сегодня меньше, чем на 5 минут
def task_2_1():
 dat = '2022-12-21'
 query = Employee\
    .select(Employee.id, Employee.fio)\
    .from_(Record\
        .select(fn.Distinct(SQL('employee_id'), SQL('rdate')),
                SQL('employee_id'),
                SQL('rdate'),
                fn.min(Record.rtime).over(partition_by=[Record.id_emp, Record.rdate]).alias('time_in'))\
        .where(Record.rtype==1)).alias('r')\
    .join(Employee, on=(Employee.id == SQL('employee_id')))\
    .where(SQL('time_in') > '09:00')\
    .where(SQL('time_in') <= '09:05')\
    .where(SQL('rdate') == dat)
 print_query(query)

#Найти сотрудников, которые выходили больше, чем на 10 минут
def task_2_2():
 now = datetime.now().year
 dt = '2022-12-21'
 query = Record\
            .select(fn.Distinct(SQL('employee_id')))\
            .from_(
                Record\
                    .select(SQL('employee_id'),
                            SQL('rdate'),
                            SQL('rtime'),
                            SQL('rtype'),
                            fn.Lag(Record.rtime).over(partition_by=[Record.id_emp, Record.rdate]).alias('prev_time'),
                            (Record.rtime - fn.Lag(Record.rtime).over(partition_by=[Record.id_emp, Record.rdate])).alias('tmp_dur'),
                            )\
                    .order_by(Record.id_emp, Record.rdate, Record.rtime)
            ).alias('small_durations')\
    .join(Employee, on=(Employee.id==SQL('employee_id')))\
    .where(SQL('tmp_dur') > '00:10:00')\
    .where(SQL('rdate') == dt)\
    .group_by(SQL('employee_id'))\
    .having(fn.count(SQL('employee_id')) > 1)
 print_query(query)

#Найти сотрудников бухгалтерии, приходивших на работу раньше 8:00
def task_2_3():
 query = Employee\
 .select(fn.Distinct(Employee.id, Employee.fio), Employee.id, Employee.fio)\
 .from_(Record\
    .select(fn.Distinct(SQL('employee_id'), SQL('rdate')),
            SQL('employee_id'),
            SQL('rdate'),
            fn.min(Record.rtime).over(partition_by=[Record.id_emp, Record.rdate]).alias('time_in'))\
    .where(Record.rtype==1)).alias('r')\
 .join(Employee, on=(Employee.id == SQL('employee_id')))\
 .where(Employee.depart == 'Fin')\
 .where(SQL('time_in') <= '8:00')
 print_query(query)

print("\nНайти сотрудников, опоздавших сегодня меньше, чем на 5 минут")
task_2_1()
print("\nНайти сотрудников, которые выходили больше, чем на 10 минут")
task_2_2()
print("\nНайти сотрудников бухгалтерии, приходивших на работу раньше 8:00")
task_2_3()