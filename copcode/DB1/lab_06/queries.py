import psycopg2 as ps2
from psycopg2 import sql
from prettytable import PrettyTable

menu_text = "0. Завершить программу.\n" \
            "1. Выполнить скалярный запрос.\n" \
            "2. Выполнить запрос с несколькими соединениями (JOIN).\n" \
            "3. Выполнить запрос с ОТВ(CTE) и оконными функциями.\n" \
            "4. Выполнить запрос к метаданным.\n" \
            "5. Вызвать скалярную функцию (написанную в третьей лабораторной работе)\n" \
            "6. Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе)\n" \
            "7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе).\n" \
            "8. Вызвать системную функцию или процедуру;\n" \
            "9. Создать таблицу в базе данных, соответствующую тематике БД.\n" \
            "10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY.\n" \
            "Выбранный пункт меню: "


# 1. Выполнить скалярный запрос.
def scalar_query(conn):
    print("\nМаксимальная стоимость обучения по всем учреждениям.")
    query = sql.SQL("select service_cost "
                    "from contract "
                    "order by service_cost desc "
                    "limit 1;")
    with conn.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()
    cursor.close()
    headings = ['Максимальная стоимость обучения']
    table = PrettyTable(headings)
    table.add_row(result[0])
    print(table, '\n')


# 2. Выполнить запрос с несколькими соединениями (JOIN).
def multi_join_query(conn):
    print("\nФИО родителей и их ребёнка, обучение которых займёт меньше 390 дней.")
    query = sql.SQL("select P.full_name as parent_name, Ch.full_name as child_name "
                    "from contract Co join child Ch on Co.id_child = Ch.id_child "
                    "join parent P on Co.id_parent = P.id_parent "
                    "where Co.training_period < '390 days';")
    with conn.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()
    cursor.close()
    headings = ['ФИО родителя', 'ФИО ребёнка']
    table = PrettyTable(headings)
    table.add_rows(result)
    print(table)


# 3. Выполнить запрос с ОТВ(CTE) и оконными функциями.
def cte_window_query(conn):
    print("\nИнформация о средней, минимальной и максимальной стоимость обучений в учреждениях")
    query = sql.SQL(
        "with CTE(ins_name, ins_phone, service_cost) "
        "as "
        "( "
        "select Ins.name, Ins.phone, C.service_cost "
        "from contract C join institution Ins on C.id_institution = Ins.id_institution "
        ") "
        "select distinct ins_name, ins_phone, "
        "avg(service_cost) over (partition by ins_name) as \"Средняя стоимость\", "
        "min(service_cost) over (partition by ins_name) as \"Минимальная стоимость\", "
        "max(service_cost) over (partition by ins_name) as \"Максимальная стоимость\" "
        "from CTE;")
    with conn.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()
    cursor.close()
    headings = ['Название учреждения', 'Телефон', 'Средняя стоимость', 'Минимальная стоимость',
                'Максимальная стоимость']
    table = PrettyTable(headings)
    table.add_rows(result)
    print(table)


# 4. Выполнить запрос к метаданным.
def metadata_query(conn):
    print("\nНазвание ограничения и название таблицы где тип ограничения - первичный ключ.")
    get_pk_constraints = sql.SQL("select constraint_name, table_name "
                                 "from information_schema.table_constraints "
                                 "where constraint_type = 'PRIMARY KEY';")
    with conn.cursor() as cursor:
        cursor.execute(get_pk_constraints)
        if cursor.rowcount > 0:
            result = cursor.fetchall()
    cursor.close()
    headings = ['Название ограничения', 'Название таблицы']
    table = PrettyTable(headings)
    table.add_rows(result)
    print(table)


# 5. Вызвать скалярную функцию (написанную в третьей лабораторной работе)
def call_scalar_func(conn):
    print("\nМаксимальная стоимость обучения по всем учреждениям.")
    with conn.cursor() as cursor:
        cursor.callproc('max_cost')
        if cursor.rowcount > 0:
            result = cursor.fetchone()
    cursor.close()
    headings = ['Максимальная стоимость обучения']
    table = PrettyTable(headings)
    table.add_row(result)
    print(table)


# 6. Вызвать табличную функцию (написанную в третьей лабораторной работе)
def call_table_func(conn):
    print("\nИнформация о персонале по переданному полу")
    gender = input("Введите пол необходимых работников (муж/жен): ")
    with conn.cursor() as cursor:
        cursor.callproc('employee_by_gender', [gender])
        if cursor.rowcount > 0:
            result = cursor.fetchall()
    cursor.close()
    headings = ['id_employee', 'id_institution', 'full_name', 'func',
                'dob', 'gender', 'phone', 'experience', 'education']
    table = PrettyTable(headings)
    table.add_rows(result)
    print(table)


# 7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе).
def stored_procedure(conn):
    print("\nДобавление всем работником 1 дня стажа")
    create_temp_table = sql.SQL("select * "
                                "into temp employee_temp "
                                "from employee;")
    get_employee_exp = sql.SQL("select full_name, experience "
                               "from employee_temp "
                               "order by full_name "
                               "limit 5;")

    headings = ['ФИО работника', 'Стаж']
    table = PrettyTable(headings)

    with conn.cursor() as cursor:
        cursor.execute(create_temp_table)
        cursor.execute(get_employee_exp)
        result = cursor.fetchall()
        table.add_rows(result)
        print(table)
        cursor.execute("call inc_experience()")
        print("Хранимая процедура вызвана.")
        table.clear_rows()
        cursor.execute(get_employee_exp)
        result = cursor.fetchall()
        table.add_rows(result)
        print(table)
    cursor.close()


# 8. Вызвать системную функцию или процедуру.
def call_sys_func(conn):
    print("\nПолучение информации о версии PosgreSQL.")
    with conn.cursor() as cursor:
        cursor.callproc('version')
        result = cursor.fetchone()
    cursor.close()
    headings = ['PostgreSQL version']
    table = PrettyTable(headings)
    table.add_row(result)
    print(table)


# 9. Создать таблицу в базе данных, соответствующую тематике БД.
def create_table(conn):
    print("\nСоздание таблицы связующей таблицы institution_group.")
    new_table = sql.SQL("create table if not exists institution_group ( "
                        "id_institution int not null, "
                        "id_group int not null, "
                        "foreign key (id_institution) references institution(id_institution), "
                        "foreign key (id_group) references groupp(id_group), "
                        "city_name varchar(50)"
                        ");")
    with conn.cursor() as cursor:
        cursor.execute(new_table)
        print(cursor.statusmessage)
    cursor.close()
    conn.commit()


# 10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY.
def fill_table(conn):
    print("\nЗаполнение созданной таблицы данными.")
    insert = sql.SQL("insert into institution_group(id_institution, id_group, city_name) "
                     "values (1, 3, 'Москва'), "
                     "(2, 2, 'Сергиев Посад'), "
                     "(3, 5, 'Озёрск'), "
                     "(1, 7, 'Мытищи'); ")
    with conn.cursor() as cursor:
        cursor.execute(insert)
        print(cursor.statusmessage)
    cursor.close()
    conn.commit()


def main():
    conn = ps2.connect(dbname='Alexei', user='postgres', host='localhost', port=5433)
    funcs = {'1': scalar_query, '2': multi_join_query, '3': cte_window_query,
             '4': metadata_query, '5': call_scalar_func, '6': call_table_func,
             '7': stored_procedure, '8': call_sys_func, '9': create_table, '10': fill_table}

    while 1:
        selected_item = input(menu_text)
        if selected_item == '0':
            break
        try:
            funcs[selected_item](conn)
        except KeyError:
            print("\nПункта с таким номером нет. Повторите ввод.\n")

    conn.close()


if __name__ == '__main__':
    main()
