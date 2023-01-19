import psycopg2
from tasks import *
from menu import *

def main():
    try:
        connection = psycopg2.connect(
                database = "postgres",
                user = "postgres",
                password = "0612",
                host="localhost",
                port="5432"	
        )
    except:
        print("Ошибка при подключении к БД")
        return
    
    print("База данных успешно открыта.")

    choice = -1
    while choice != 0:
        output_menu()
        print(f'Выберите пункт меню:')
        choice = int(input())
        if choice == 1:
            do_task_1(connection)
        elif choice == 2:
            do_task_2(connection)
        elif choice == 3:
            do_task_3(connection)
        elif choice == 4:
            do_task_4(connection)
        elif choice == 5:
            do_task_5(connection)
        elif choice == 6:
            do_task_6(connection)
        elif choice == 7:
            do_task_7(connection)
        elif choice == 8:
            do_task_8(connection)
        elif choice == 9:
            do_task_9(connection)
        elif choice == 10:
            do_task_10(connection)

    connection.close()
    print("База данных успешно закрыта.")
    pass

if __name__ == "__main__":
    main()