from task3 import *

def chooseTask():
    try:
        task = 1
        while task != 0:
            print('\nВыбери пункт меню:\n' +\
                '1 - Link to Object\n' +\
                '2 - Link to JSON\n' +\
                '3 - Link to SQL\n' +\
                '0 - Выход')
            task = int(input('Введи номер задания: '))
            if task > 0 and task <= 3:
                if task == 1:
                    pass
                elif task == 2:
                    pass
                elif task == 3:
                    task3()
            elif task == 0:
                print('Конец программы.')
            else:
                print('Читай условие внимательнее...')
    except ValueError:
        print('Надо было число...')

if __name__ == "__main__":
    chooseTask()