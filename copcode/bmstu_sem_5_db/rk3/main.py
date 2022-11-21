#2 вариант
from peewee import *
from datetime import *

connect = PostgresqlDatabase(database='postgres',
                                user='postgres',
                                password='Deadly_Hunter_38',
                                host='127.0.0.1', 
                                port=5432
                            )

class BaseModel(Model):
	class Meta:
		database = connect

class Employees(BaseModel):
    id_employee = IntegerField(column_name="id_employee")
    surname = CharField(column_name='surname')
    birthday = DateField(column_name='birthday')
    department = CharField(column_name='department')
    
    class Meta:
        table_name = 'employees'

class Time_in_out(BaseModel):
    id = IntegerField(column_name = 'id')
    id_employee = ForeignKeyField(Employeees, column_name='id_employee')
    sysdate_day = DateField(column_name='sysdate_day')
    week_day = CharField(column_name='week_day')
    sysdate_time = TimeField(column_name='sysdate_time')
    type_late = IntegerField(column_name ='type_late')
    
    class Meta:
        table_name = 'time_in_out'

def print_query(query):
    for elem in query.dicts().execute():
        print(elem) 

def output(cur):
    rows = cur.fetchall()
    for elem in rows:
        print(*elem)
    print()

def do_queries_task_1():
    print("1. НАйти все отделы, в которых нет сотрудников младше 25 лет.")
    age = datetime.now().year - Employees.birthday.year
    query = Employees.select(Employee.department).where(age > '25')
    print_query(query)

    print("2. Найти сотрудника, который пришел на работу раньше всех.")
    query = Time_in_out.select(fn.Min(Time_in_out.sysdate_time).alias('min_time_in')).where(
        Time_in_out.type_late == 1 and Time_in_out.sysdate_day == date.today())
    min_time_in = query.dicts.execute()

    query = Time_in_out.select(Time_in_out.id_employee).where(
        Time_in_out.sysdate_time == min_time_in[0]['min_time_in']).where(Time_in_out.type_late == 1 and Time_in_out.sysdate_day == date.today()).limit(1)
    print_query(query)

    print("3. Найти сотрудников, опоздавших не менее пяти раз.")
    query = Employees.select(Employees.id_employee, Employees.surname).join(Time_in_out).where(Time_in_out.sysdate_time > '09:00:00').where(
        Time_in_out.type_late == 1).group_by(Employees.id_employee, Employees.surname).having(fn.Count(
            (Employees.id_employee) > 5))
    print_query(query)

def do_queries_task_2(connect):
    cursor = connect.cursor()
    print("Задание 1:")
    cursor.execute('''
                    select department
                    from employees
                    where ((extract(year from current_date)) - extract(year from birthday)) > 25)
                   ''')
    
    output(cursor)

    
    cursor.execute('''
                    select employees.id_employee, employees.surname
                    from time_in_out join employees on time_in_out.id_employee = employees.id_employee
                    where date = current_date and late_type = 1 and time in

                   ''')
    print("Задание 2:")
    output(cursor)

    cursor.close()


def do_task_1():
    global connect 
    do_queries_task_1()
    connect.close()

def do_task_2():
    global connect
    do_queries_task_2(connect)
    connect.close()


def main():
	do_task_1()
    do_task_2()

if __name__ == "__main__":
	main()