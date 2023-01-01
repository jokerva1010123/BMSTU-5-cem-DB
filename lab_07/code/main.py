from menu import *
from task_1 import *
from task_2 import *
from task_3 import *

def main():
    choice = -1
    while choice != 0:
        output_menu()
        print(f'Выберите пункт меню: ', end = '')
        choice = int(input())
        if choice == 1:
            do_task_1()
        elif choice == 2:
            do_task_2()
        elif choice == 3:
            do_task_3()


if __name__ == "__main__":
    main()