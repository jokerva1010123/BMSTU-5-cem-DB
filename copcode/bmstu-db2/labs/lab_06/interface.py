def mainMenu():
    print('\nВыбери нужный пункт меню:\n' +\
        '> 1 - Скалярный запрос\n' +\
        '> 2 - Запрос с несколькими соединениями (join)\n' +\
        '> 3 - Запрос с ОТВ и оконными функциями\n' +\
        '> 4 - Запрос к метаданным\n' +\
        '> 5 - Скалярная функция (из 3 ЛР)\n' +\
        '> 6 - Многооператорная или табличная функция (из 3 ЛР)\n' +\
        '> 7 - Хранимая процедура (из 3 ЛР)\n' +\
        '> 8 - Системаня функция или процедура\n' +\
        '> 9 - Создание таблицы в БД, соответствующую тематике\n' +\
        '> 10 - Вставка данных в новую таблицу (через insert или copy)\n' +\
        '11 - Добавление нового преподавателя\n' +\
        '> 0 - Выход\n')

    try:
        task = int(input('Выбери пункт меню: '))
        if task >= 0 and task <= 11:
            if task == 0:
                print('Ну все, пока =)')
        else:
            task = -1
            print('Не нашлось такой цифры. Повторю вопрос...')
    except ValueError:
        print('Ну просили же пункт выбрать, а не что-то другое(')
        task = -1

    return task

def action(cur, task, cnnct):
    if task == 1:
        print('-- Количество экзаменов с определенной оценкой')
        try:
            m = int(input('Введи искомую оценку (от 2 до 5): '))
            if m >= 2 and m <= 5:
                cur.execute(" \
                    select count(*) \
                    from sc1.exam \
                    where mark = " + str(m))
                row = cur.fetchone()
                print('Количество учеников сдавших экзамен на {} равно {}'.format(m, row[0]))
            else:
                print('Просили же от 2 до 5...')
        except ValueError:
            print('Просили число...')
    elif task == 2:
        print('-- Полная информация о прошедших экзаменах (первые 100 строк)')
        cur.execute(" \
            select e.id as id, s.fullname as student, t.fullname as teacher, \
            c.title as composition, mark\
            from sc1.exam e join sc1.student s on e.studentid = s.id \
            join sc1.teacher t on e.teacherid = t.id \
            join sc1.composition c on e.compositionid = c.id \
            where e.id <= 100 \
            order by e.id")
        rows = cur.fetchall()
        print('  № |' + ' ' * 8 + 'Student' + ' ' * 7 + '|' +\
            ' ' * 8 + 'Teacher' + ' ' * 7 + '|' + ' ' * 8 + 'Composition' + ' ' * 8 +\
            '| Mark')
        print('-' * 85)
        for elem in rows:
            print('{:3d} | {:20s} | {:20s} | {:25s} | {} '.format(elem[0], elem[1], elem[2], elem[3], elem[4]))
    elif task == 3:
        print('-- Вывод учителей, их возраста и количества их одногодок')
        cur.execute(" \
            with new(name, age, count_of_same_years) as ( \
                select fullname, age, count(age) over (partition by age) as cnt \
                from sc1.teacher \
            ) \
            select *\
            from new \
            order by name")
        rows = cur.fetchall()
        print(' ' * 9 + 'Name' + ' ' * 9 + '| Age | Cnt Same Years')
        print('-' * 40)
        for i in range(100):
            elem = rows[i]
            print(' {:20s} | {:3d} | {:3d} '.format(elem[0], elem[1], elem[2]))
    elif task == 4:
        print('-- Вывод имеющихся на базу данных триггеров')
        cur.execute(" \
            select trigger_catalog, trigger_name, event_manipulation \
            from information_schema.triggers")
        rows = cur.fetchall()
        if not rows:
            print('Триггеров не существует...')
        else:
            print('    trigger_catalog   |     trigger_name     | event_manipulation')
            print('-' * 70)
            for elem in rows:
                print(" {:20s} | {:20s} | {:20s}".format(elem[0], elem[1], elem[2]))
    elif task == 5:
        print('-- Средня оценка экзаменов студентов между id1 и id2')
        try:
            print('--ID1 ДОЛЖНО БЫТЬ МЕНЬШЕ ID2!--')
            id1 = int(input('Введи id1 (целое число от 1 до 1000): '))
            id2 = int(input('Введи id2 (целое число от 1 до 1000): '))
            if id1 > 0 and id1 <= 1000 and id2 > 0 and id2 <= 1000 and id2 > id1:
                cur.execute("select distinct sc1.avgexammark(%s, %s)", (id1, id2))
                row = cur.fetchone()
                print('Средняя оценка за экзамен учеников с id от {} до {} равна {:.2f}'.format(id1, id2, row[0]))
            else:
                print('Ну посмотри ты внимательно подсказку ко вводу.')
        except ValueError:
            print('Просили число...')
    elif task == 6:
        print('-- Изменение оценки от преподавателя tid с 3 на 5 и удаляение оценки 2, вывод результирующей таблицы')
        try:
            tid = int(input('Введи id преподавателя (целое число от 1 до 1000): '))
            if tid > 0 and tid <= 1000:
                pass
                cur.execute("select * \
                    from sc1.conteacherexam(%s)", (tid,))
                rows = cur.fetchall()
                if not rows:
                    print('Этот преподаватель не принимал экзамены...')
                else:
                    print(' ' * 8 + 'Student' + ' ' * 7 + '|' +\
                        ' ' * 8 + 'Teacher' + ' ' * 7 + '|' + ' ' * 8 + 'Composition' + ' ' * 8 +\
                        '| Mark')
                    print('-' * 85)
                    for elem in rows:
                        print(' {:20s} | {:20s} | {:25s} | {} '.format(elem[0], elem[1], elem[2], elem[3]))
            else:
                print('А подсказку посмотреть?')
        except ValueError:
            print('Нужно ввести число...')
    elif task == 7:
        print('-- Обновление тональности произведений автора с cid')
        try:
            cid = int(input('Введи id автора (целое число от 1 до 1000): '))
            if cid > 0 and cid <= 1000:
                cur.execute("call sc1.rewriteTonality(%s)", (cid,))
                print('Переписано!')
                cur.execute("select * \
                    from sc1.composition \
                    where composerid = " + str(cid))
                rows = cur.fetchall()
                if not rows:
                    print('Этот автор не писал произведений...')
                else:
                    print('  №   |' + ' ' * 11 + 'Title' + ' ' * 11 + '|  Tonality  |Amount|ComposerId')
                    print('-' * 70)
                    for elem in rows:
                        print(' {:4d} | {:25s} | {:10s} | {:4d} | {:4d} '.format(elem[0], elem[1], elem[2], elem[3], elem[4]))
            else:
                print('Смотри подсказку внимательней.')
        except ValueError:
            print('Нужно ввести число...')
    elif task == 8:
        print('-- Текущий запрос, порт и текущая версия psql')
        cur.execute("select current_query(), inet_server_port(), version()")
        row = cur.fetchone()
        print('Current query: {} \nPort: {} \nPSQL version: {}'.format(row[0], row[1], row[2]))
    elif task == 9:
        print('-- Создание таблицы конкурсов')
        cur.execute(" \
            select * \
            from information_schema.tables \
            where table_name = 'contest'")
        if cur.fetchone():
            print('Такая таблица уже существует!')
            return

        cur.execute(" \
            create table sc1.contest \
            ( \
                id int generated by default as identity \
	            (start with 1 increment by 1) primary key,\
                title text not null, \
                city text, \
                level int check (level > 0)\
            )") 
        print('Таблица успешно создана!')  
        cnnct.commit()     
    elif task == 10:
        print('-- Вставка значений в таблицу конкурсов')
        cur.execute(" \
            select * \
            from information_schema.tables \
            where table_name = 'contest'")
        if not cur.fetchone():
            print('Такой таблицы еще не существует. Создай ее в пункте 9')
            return

        try:
            title = input('Введи название конкурса: ')
            city = input('Введи город проведения конкурса: ')
            level = int(input('Введи уровень конкурса (целое число больше 0): '))
            try:
                cur.execute(" \
                    insert into sc1.contest (title, city, level) \
                    values(%s, %s, %s)", (title, city, level,))
                print('Выполнено!')
                cnnct.commit()
            except:
                print('Упс, неудача. Попробуй снова')
                cnnct.rollback()
        except ValueError:
            print('Там в одном поле нужно было число')
    elif task == 11:
        cur.execute(" \
            select * \
            from information_schema.tables \
            where table_name = 'teacher'")
        if not cur.fetchone():
            print('Такой таблицы еще не существует. Кто-то плохой удалил преподавателей :(')
            return

        try:
            fullname = input('Введи ФИО преподавателя: ')
            gender = input("Введи пол ('f' или 'm'): ")
            if gender == 'f':
                gender = 'female'
            else:
                gender = 'male'
            age = int(input('Введи возраст преподавателя (положительное число): '))
            while age < 0:
                print('Ну положительное же!')
                age = int(input('Введи возраст преподавателя (положительное число): '))
            education = input('Введи образование преподавателя: ')
            try:
                cur.execute(" \
                    insert into sc1.teacher (fullname, gender, age, education)\
                    values(%s, %s, %s, %s)", (fullname, gender, age, education,))
                print('Выполнено!')
                cnnct.commit()
            except:
                print('Ошибочка вышла. Повтори')
                cnnct.rollback()
        except ValueError:
            print('Там где-то нужно было число.')