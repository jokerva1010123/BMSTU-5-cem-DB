import psycopg2 # type: ignore
from interface import *

def main():
    try:
        cnnct = psycopg2.connect(
            database = "musicschool",
            user = "postgres",
            password = "0509",
            host = "localhost",
            port = "5432"
        )
        print('Опа, подключились!')
    except:
        print('Подключения не будет, расходимся.')
        return

    cur = cnnct.cursor()
    code = mainMenu()
    while code != 0:
        if code >= 1 and code <= 11:
            action(cur, code, cnnct)
        code = mainMenu()

    cur.close()
    cnnct.close()
    print('Закрыто!')

if __name__ == "__main__":
    main()