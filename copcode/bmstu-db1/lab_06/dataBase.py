from psycopg2 import connect

class dataBase:
    def __init__(self):
        try:
            self.__connection = connect(host = "localhost",
                                        user = "regina",
                                        password = "postgres",
                                        database = "wine-sales")
            self.__connection.autocommit = True
            self.__cursor = self.__connection.cursor()

            print("\nConnection - opened.\n")
        except Exception as error:
            print("\nError with connection:\n", error)
            return


    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()

            print("\nConnection - closed.\n")
    

    def execute_query(self, file, num):
        try:
            f = open(file, "r")

            print("\n\n=== TASK", num, " ===\n")
            task = f.readline()
            print(task)

            query = f.read()
            self.__cursor.execute(query)
            result = self.__cursor.fetchall()
            self.print_result(result)

        except Exception as error:
            print("\nError with executing query:\n", error)

    
    def print_result(self, result):
        print("=== RESULT  ===\n")
        for i in range(len(result)):
            for j in range(len(result[0])):
                print(result[i][j], " ", end = "")
            print("")
    

    def scalar_query(self):
        self.execute_query("scalar_query.sql", 1)


    def multiple_join(self):
        self.execute_query("multiple_join.sql", 2)


    def window_func(self):
        self.execute_query("window_func.sql", 3)


    def meta_query(self):
        self.execute_query("meta_query.sql", 4)


    def scalar_func(self):
        self.execute_query("scalar_func.sql", 5)


    def table_func(self):
        self.execute_query("table_func.sql", 6)


    def stored_procedure(self):
        self.execute_query("stored_procedure.sql", 7)


    def system_func(self):
        self.execute_query("system_func.sql", 8)

    
    def create_table(self):
        try:
            f = open("creation.sql", "r")

            print("\n\n=== TASK 9 ===\n")
            task = f.readline()
            print(task)

            last_notice = len(self.__connection.notices)

            query = f.read()
            self.__cursor.execute(query)

            for notice in self.__connection.notices[last_notice:]:
                print(notice)
            
            print("Creation of tables - passed.")

        except Exception as error:
            print("\nError with creation table:\n", error)

    def insert_into_table(self):
        self.execute_query("insert_into_table.sql", 10)
    

    def input_to_manufactures(self):
        try:
            f = open("create_table.sql", "r")

            creation = f.read()
            self.__cursor.execute(creation)

            print("\nВставка в таблицу поставщиков")

            id = int(input("Введите id: "))
            name = input("Введите название поставщика: ")
            country = input("Введите страну поставщика: ")
            experience = int(input("Введите опыт: "))
            price = int(input("Введите цену поставки:"))
            rating = int(input("Введите рейтинг: "))

            insert = """
                    INSERT INTO manufacturers(manufacturer) VALUES
                    ('{"id": """ + str(id) + """, "name": \"""" + name + """\", "country": \"""" + country + """\", "experience": \"""" + str(experience) + """\", "price": \"""" + str(price) + """\", "rating": \"""" + str(rating) + """\"}');
                    SELECT *
                    FROM manufacturers;
                     """
            self.__cursor.execute(insert)
            result = self.__cursor.fetchall()

            self.print_result(result)

        except Exception as error:
            print("\nError with task:\n", error)           
