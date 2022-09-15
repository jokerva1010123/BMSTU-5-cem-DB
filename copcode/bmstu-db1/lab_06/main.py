from dataclasses import dataclass
from dataBase import dataBase

@dataclass
class Menu:
    """
        Константы необходимые в меню.
    """

    msg = "\nМЕНЮ:\n" + \
          "1. Выполнить скалярный запрос\n" + \
          "2. Выполнить запрос с несколькими соединениями (JOIN)\n" + \
          "3. Выполнить запрос с ОТВ(CTE) и оконными функциями\n" + \
          "4. Выполнить запрос к метаданными\n" + \
          "5. Вызвать скалярную функцию\n" + \
          "6. Вызвать табличную функцию\n" + \
          "7. Вызвать хранимую процедуру\n" + \
          "8. Вызвать системную функцию\n" + \
          "9. Создать таблицу в базе данных, соответствующую тематике БД\n" + \
          "10. Выполнить вставку данных в созданную таблицу\n11. Вставить в таблицу поставщиков\n" + \
          "0. Выход\n" + \
          "Выбор: "

    exit = 0
    scalar_query = 1
    multiple_join = 2
    window_func = 3
    meta_query = 4
    scalar_func = 5
    table_func = 6
    stored_proc = 7
    system_func = 8
    create_table = 9
    insert_into_table = 10
    input_to_manufactures = 11


def process():
    database = dataBase()
    process = True

    while process:
        command = int(input(Menu.msg))

        if command == Menu.scalar_query:
            database.scalar_query()
        elif command == Menu.multiple_join:
            database.multiple_join()
        elif command == Menu.window_func:
            database.window_func()
        elif command == Menu.scalar_func:
            database.scalar_func()
        elif command == Menu.table_func:
            database.table_func()
        elif command == Menu.stored_proc:
            database.stored_procedure()
        elif command == Menu.system_func:
            database.system_func()
        elif command == Menu.meta_query:
            database.meta_query()
        elif command == Menu.create_table:
            database.create_table()
        elif command == Menu.insert_into_table:
            database.insert_into_table()
        elif command == Menu.input_to_manufactures:
            database.input_to_manufactures()
        elif command == Menu.exit:
            process = False
        else:
            print("\nВыбран неверный пункт меню.\n")


if __name__ == "__main__":
    process()
