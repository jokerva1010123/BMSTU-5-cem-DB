from psycopg2 import connect

from constants import *
from faker import *
from random import choice, randint


class dataBase:
    def __init__(self):
        try:
            self.__connection = connect(host = "localhost",
                                        user = "regina",
                                        password = "postgres",
                                        database = "wine-sales")
            self.__connection.autocommit = True
            self.__cursor = self.__connection.cursor()

            print("\nDatabase init - passed.\n")
        except Exception as err:
            print("\nError with connection:\n", err)
            return


    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()


    def create_tables(self):
        """
            Создание таблиц.
        """

        try:
            self.__cursor.execute(open("scripts/creation.sql", "r").read())

            print("Creation of tables - passed.")

            self.__cursor.execute(open("scripts/check_constraints.sql", "r").read())

            print("Restrictins of tables - passed.\n")
        except Exception as err:
            print("\nError with creation:\n", err)
            return


    def delete_tables(self):
        """
            Удаление таблиц.
        """

        try:
            self.__cursor.execute("DROP TABLE wines, customers, manufactures, sales")

            print("Deletion of tables - passed.\n")
        except Exception as err:
            print("\nError with deletion:\n", err)
            return


    def copy_tables(self):
        """
            Копирование таблиц.
        """

        try:
            self.__cursor.execute(open("scripts/copying.sql", "r").read())

            print("Copying of tables - passed.\n")
        except Exception as err:
            print("\nError with copying:\n", err)
            return


def generate_wines():
    """
        Сгенерировать таблицу
        вин.
    """

    file = open(WINE_FILE, "w")

    for _ in range(COUNT_RECORDS):
        color = choice(WINE_СOLORS)
        sugar = choice(SUGAR)

        if color == "red":
            sort = choice(RED_SORTS)
        elif color == "white":
            sort = choice(WHITE_SORTS)
        elif color == "pink":
            sort = choice(PINK_SORTS)
        
        aciding = randint(MIN_ACIDING, MAX_ACIDING) + 0.5
        aging = randint(MIN_YEAR, MAX_YEAR)
        volume = choice(VOLUMES)

        line = "{0}|{1}|{2}|{3}|{4}|{5}\n".format(color, sugar, sort, aciding, aging, volume)
        file.write(line)
    
    file.close()

    print("Wine table created - 25 %")


def generate_customers():
    """
        Сгенерировать таблицу
        покупателей.
    """

    faker = Faker()

    file = open(CUSTOMERS_FILE, "w")

    for _ in range(COUNT_RECORDS):
        first_name = faker.first_name()
        last_name = faker.last_name()
        age = randint(MIN_AGE, MAX_AGE)
        card = choice([True, False])

        if card:
            bonuses = randint(MIN_BONUS, MAX_BONUS)
        else:
            bonuses = 0

        line = "{0}|{1}|{2}|{3}|{4}\n".format(first_name, last_name, age, card, bonuses)
        file.write(line)
    
    file.close()

    print("Table of customers created - 50 %")


def generate_manufactures():
    """
        Сгенерировать таблицу
        поставщиков.
    """

    prices = []

    faker = Faker()

    file = open(MANUFACTURES_FILE, "w")

    for _ in range(COUNT_RECORDS):
        name = faker.unique.company()
        country = choice(COUNTRIES)
        experience = randint(MIN_EXP, MAX_EXP)
        price = randint(MIN_PRICE, MAX_PRICE)
        prices.append(price)
        rating = randint(MIN_RATING, MAX_RATING)

        line = "{0}|{1}|{2}|{3}|{4}\n".format(name, country, experience, price, rating)
        file.write(line)
    
    file.close()

    print("Table of manufactures created - 75 %")

    return prices


def generate_sales(prices):
    """
        Сгенерировать таблицу
        продаж.
    """

    wines = [i for i in range(1, COUNT_RECORDS + 1)]
    manufactures = [i for i in range(1, COUNT_RECORDS + 1)]
    customers = [i for i in range(1, COUNT_RECORDS + 1)]

    file = open(SALES_FILE, "w")

    for _ in range(COUNT_RECORDS):
        wine_id = choice(wines)
        wines.remove(wine_id)

        manufacture_id = choice(manufactures)
        manufactures.remove(manufacture_id)

        customer_id = choice(customers)
        customers.remove(customer_id)

        price = round(prices[manufacture_id - 1] + \
                      PERCENT * prices[manufacture_id - 1])
        profit = price - prices[manufacture_id - 1]

        line = "{0}|{1}|{2}|{3}|{4}\n".format(wine_id, manufacture_id,
                                          customer_id, price, profit)
        file.write(line)
    
    file.close()

    print("Table of sales created - 100%\n")


if __name__ == "__main__":

    database = dataBase()
    database.delete_tables()
    database.create_tables()

    generate_wines()
    generate_customers()
    prices = generate_manufactures()
    generate_sales(prices)

    database.copy_tables()
