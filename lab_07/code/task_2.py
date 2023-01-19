<<<<<<< HEAD
from peewee import *
from animals import *
import json
import psycopg2

from playhouse.shortcuts import model_to_dict, dict_to_model

def connection():
	connect = None
	# Подключаемся к БД.
	try:
		connect = psycopg2.connect(
			database="postgres",
			user="postgres",
			password="0612",
			host="localhost",  # Адрес сервера базы данных.
			port="5432"		   # Номер порта.
		)
	except:
		print("Ошибка при подключении к БД")
		return connect

	print("База данных успешно открыта")
	return connect

def read_table_json(cursor):
    cursor.execute("select * from animals_import")
    rows = cursor.fetchmany(15)

    array = list()
    for elem in rows:
      tmp = elem[0]
      array.append(Animals(tmp['id'], tmp['animal_name'], tmp['kind'], tmp['age'], tmp['id_owner'],
      tmp['id_vet'], tmp['id_diagnosis'], tmp['id_treatment']).get())

    print(*array, sep='\n')
    return array

def update_animals(animals, in_id):
    for elem in animals:
      print(elem)
      if elem['id'] == in_id:
          elem['age'] += 1
    for elem in animals:
        print(elem)

def add_animal(animals, animal):
      animals.append(animal.get())
      for elem in animals:
        print(elem)


def do_task_2():
    print("LINQ to JSON. Создать JSON документ, извлекая его из таблиц" +
          "нашей БД спомощью инструкции select. Создать три запроса:\n" +
          "1. Чтение из JSON документа.\n" + 
          "2. Обновление JSON документа" +
          "3. Запись (добавление) в JSON документ.")

    connect = connection()
    cursor = connect.cursor()

    animals = read_table_json(cursor)
    update_animals(animals, 8)

    add_animal(animals, Animals(1021, 'Алай', 'Бык', 20, 1, 500, 123, 652))
    
    cursor.close()
    connect.close()

=======
from peewee import *
from animals import *
import json
import psycopg2

from playhouse.shortcuts import model_to_dict, dict_to_model

def connection():
	connect = None
	# Подключаемся к БД.
	try:
		connect = psycopg2.connect(
			database="postgres",
			user="postgres",
			password="0612",
			host="localhost",  # Адрес сервера базы данных.
			port="5432"		   # Номер порта.
		)
	except:
		print("Ошибка при подключении к БД")
		return connect

	print("База данных успешно открыта")
	return connect

def read_table_json(cursor):
    cursor.execute("select * from animals_import")
    rows = cursor.fetchmany(15)

    array = list()
    for elem in rows:
      tmp = elem[0]
      array.append(Animals(tmp['id'], tmp['animal_name'], tmp['kind'], tmp['age'], tmp['id_owner'],
      tmp['id_vet'], tmp['id_diagnosis'], tmp['id_treatment']).get())

    print(*array, sep='\n')
    return array

def update_animals(animals, in_id):
    for elem in animals:
      print(elem)
      if elem['id'] == in_id:
          elem['age'] += 1
    for elem in animals:
        print(elem)

def add_animal(animals, animal):
      animals.append(animal.get())
      for elem in animals:
        print(elem)


def do_task_2():
    print("LINQ to JSON. Создать JSON документ, извлекая его из таблиц" +
          "нашей БД спомощью инструкции select. Создать три запроса:\n" +
          "1. Чтение из JSON документа.\n" + 
          "2. Обновление JSON документа" +
          "3. Запись (добавление) в JSON документ.")

    connect = connection()
    cursor = connect.cursor()

    animals = read_table_json(cursor)
    update_animals(animals, 8)

    add_animal(animals, Animals(1021, 'Алай', 'Бык', 20, 1, 500, 123, 652))
    
    cursor.close()
    connect.close()

>>>>>>> 6a1432358f78568cbef2fb6ac12b2d861fa1affd
    pass