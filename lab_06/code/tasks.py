x = 5
def do_task_1(connection):
    '''
    Выполнить скалярный запрос
    Вывести количество ветеринаров, которые попадают в группу риска (старше 60 лет)
    '''
    cursor = connection.cursor()  
    cursor.execute("select count(*) as age \
                 from veterinarian as vets \
                 where vets.age >= 60")

    result_count = cursor.fetchone()
    print(f'Количесво врачей, попающих в группу риска: {result_count[0]}')


def do_task_2(connection):
    '''
    Выполнить запрос с несколькими соединениями (join)
    Посмотреть общее число животных, у которых продолжительность лечения одинакова
    '''
    cursor = connection.cursor()
    result = list()
    for i in range(5, 31):
        cursor.execute("select treatment.duration, animals.kind, treatment.cost, count (*) \
                        from animals join diagnosis on animals.id_diagnosis = diagnosis.id_diagnosis \
			                         join treatment on animals.id_treatment = treatment.id_treatment \
                        where treatment.duration = %s \
                        group by treatment.duration, animals.kind, treatment.cost", (i,))

        result.append(cursor.fetchall())

    
    for i in range(len(result)):
        print('---------------------')
        for row in result[i]:
            print(row)


def do_task_3(connection):
    '''
    Выполнить запрос с ОТВ(СТЕ) и оконными функциями.
    Вывести среднюю стоимость лечения в зависимости от продожительности лечения
    '''
    cursor = connection.cursor()
    cursor.execute("with compared_salary as \
                    ( \
                    select name, duration, cost, avg(cost) over (partition by duration) \
                    from treatment \
                    ) \
                    select * from compared_salary")
    result = cursor.fetchall()

    for row in result:
        print(row)

def do_task_4(connection):
    '''
    Выполнить запрос к метаданным.
    Выписать все функции текущей схемы в данной БД
    '''
    schema_name = 'public'
    cursor = connection.cursor()
    cursor.execute("select routines.routine_name \
                    from information_schema.routines left join information_schema.parameters on routines.specific_name = parameters.specific_name \
                    where routines.specific_schema = %s \
                    group by routines.routine_name", (schema_name,))
    result = cursor.fetchall()

    for row in result:
        print(row)

def do_task_5(connection):
    '''
    Вызвать скалярную функцию из ЛР3
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    select * from animals where animals.kind = 'Змея' and animals.age = min_age('Змея')
                    """)
    result_count = cursor.fetchone()
    print(f'Количество уволенных сотрудников: {result_count[0]}')
    pass

def do_task_6(connection):
    '''
    Вызвать многоператорную или табличную функцию из ЛР3.
    Вывести всех врачей, которые лечили больше животных, чем врач ... (вывести информацию о врачах, количестве их животных)
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    select *
                    from visit_vet('Авксентьева')
                   """)
    if cursor:
        result_list = list()
        row = cursor.fetchone()
        result_list.append(row)
        while row is not None:
            row = cursor.fetchone()
            result_list.append(row)

        for row in result_list:
            if row != None:
                print(row)


def do_task_7(connection):
    '''
    Вызвать хранимую процедуру из ЛР3.
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    call update_vet_post('Абакумов');
                    select * from veterinarian where veterinarian.surname = 'Абакумов';
                   """)

def do_task_8(connection):
    '''
    Вызвать системную функцию или процедуру.
    Функция выводит имя текущей базы данных
    '''
    cursor = connection.cursor()
    cursor.execute("SELECT current_database()")
    print(cursor.fetchall()[0][0])

def do_task_9(connection):
    '''
    Создать таблицу в базе данных, соответствующей тематике БД.
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    drop table if exists hosts;
                    create table hosts
                    (
                        host_name varchar,
                        host_age int,

                        id_animal int,
                        foreign key(id_animal) references animals(id)
                    )
                   """)

    connection.commit()

    print(f'Таблица успешно создана.')

def do_task_10(connection):
    '''
    Выполнить вставку данных в созданную таблицу с использованием insert или copy.
    '''
    cursor = connection.cursor()
    name = input('Input name:')
    age = input('Input age: ')
    id_animal = input('Input id animal: ')
    try:
        cursor.execute("insert into hosts values (%s, %s, %s);", (name, age, id_animal))
        cursor.execute("""select * from hosts;""")
    except:
        print("Ошибка: некорректный запрос")
        connection.rollback()
        return

    connection.commit()
    

    result = list()
    row = cursor.fetchone()
    result.append(row)
    while row is not None:
        row = cursor.fetchone()
        result.append(row)
    
    for row in result:
        if row != None:
            print(row)
    cursor.close()

'''
    cursor = connection.cursor()
    cursor.execute("""
                    insert into hosts values
                    (7, 'Марк', 25, 15);

                    select *
                    from hosts
                   """)

    connection.commit()
    result = list()
    row = cursor.fetchone()
    result.append(row)
    while row is not None:
        row = cursor.fetchone()
        result.append(row)
    
    print("Результат добавления нового хозяина:")
    for row in result:
        if row != None:
            print(row)
    print()

    cursor.execute("""
                    update hosts
                    set host_name = 'Женя'
                    where id_host = 7;

                    select *
                    from hosts
                   """)

    connection.commit()
    result = list()
    row = cursor.fetchone()
    result.append(row)
    while row is not None:
        row = cursor.fetchone()
        result.append(row)
    print("Результат изменения имени хозяина:")
    for row in result:
        if row != None:
            print(row)
    print()

    cursor.execute("""
                    delete from hosts
                    where host_name = 'Женя';

                    select *
                    from hosts
                   """)

    connection.commit()
    result = list()
    row = cursor.fetchone()
    result.append(row)
    while row is not None:
        row = cursor.fetchone()
        result.append(row)
    
    print("Результат удаления имени хозяина:")
    for row in result:
        if row != None:
            print(row)'''