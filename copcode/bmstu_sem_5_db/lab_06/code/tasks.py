def do_task_1(connection):
    '''
    Выполнить скалярный запрос
    Вывести количество ветеринаров, которые попадают в группу риска (старше 60 лет)
    '''
    cursor = connection.cursor()  
    cursor.execute("select count(*) as age \
                 from veterinarians as vets \
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
        cursor.execute("select treatments.duration, animals.kind, treatments.cost, count (*) \
                        from animals join diagnoses on animals.id_diagnosis = diagnoses.id_diagnosis \
			                         join treatments on animals.id_treatment = treatments.id_treatment \
                        where treatments.duration = %s \
                        group by treatments.duration, animals.kind, treatments.cost", (i,))

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
                    select treatment_name, duration, cost, avg(cost) over (partition by duration) \
                    from treatments \
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
                    select output_count_retired_employees()
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
                    from more_animals('Лутьянов')
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
                    call define_submission();
                    select *
                    from vets_submission_result;
                   """)

def do_task_8(connection):
    '''
    Вызвать системную функцию или процедуру.
    Вывести приоритет врачей.
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    create temp table if not exists vets_submission
                    (
                        id_vet int primary key,
                        boss_id_vet int references vets_submission(id_vet),
                        surname varchar(20)
                    );

                    insert into vets_submission(id_vet, boss_id_vet, surname)
                    values
                    (0, null, 'Абрамова'),
                    (1, 0, 'Абакумов'),
                    (2, 3, 'Аверкова'),
                    (3, 0, 'Аврамов'),
                    (4, 2, 'Абрикосов'),
                    (5, 4, 'Абросимова'),
                    (6, 1, 'Авдеева');

                    create temp table if not exists vets_submission_result
                    (
                        surname varchar(20),
                        level int
                    );

                    call define_submission();

                    select *
                    from vets_submission_result;
                   """)
    result = cursor.fetchall()

    print(f'Список врачей:')
    for i in range(len(result)):
        print(result[i])

def do_task_9(connection):
    '''
    Создать таблицу в базе данных, соответствующей тематике БД.
    '''
    cursor = connection.cursor()
    cursor.execute("""
                    drop table if exists hosts;
                    create table hosts
                    (
                        id_host int primary key,
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
    cursor.execute("""
                    insert into hosts values
                    (1, 'Дима', 15, 5),
                    (2, 'Миша', 12, 3),
                    (3, 'Ваня', 9, 8),
                    (4, 'Лена', 17, 1),
                    (5, 'Катя', 20, 10);

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
    
    for row in result:
        if row != None:
            print(row)

def do_task_11(connection):
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
            print(row)