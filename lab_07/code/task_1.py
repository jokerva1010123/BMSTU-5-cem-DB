from py_linq import *
from animals import *
from vets import *

def output_task_1():
    print("\nЗадание: LINQ to Object. Создать не менее пяти запросов с использованием всех\n" +
          "ключевых слов выражения запроса. Object - коллекция объектов, структура\n" +
          "которых полностью соответсвует одной из таблиц БД, реализованной в первой ЛР.")

def do_task_1():
    output_task_1()
    animals = Enumerable(import_animals('D:/BMSTU/BMSTU-5-cem-DB/lab_01/database_csv/animals.csv'))
    veterinarians = Enumerable(import_vets('D:/BMSTU/BMSTU-5-cem-DB/lab_01/database_csv/veterinarians.csv'))
    result = perform_query_1(animals)
    output_result(result)

    result = perform_query_2(animals, veterinarians)

    perform_query_3(animals)
    perform_query_4(animals)
    perform_query_5(animals)
    pass


def perform_query_1(animals):
    print("Запрос 1: Найти всех животных в возрасте 15 и 16 лет.")
    result = animals.where(lambda x: x['age'] >= 15 and x['age'] <= 16).order_by(lambda x: x['animal_name']).select(lambda x: [x['id'], x['animal_name'], x['kind'],
                                                                                x['age'], x['id_vet'], x['id_diagnosis'], x['id_treatment']])
    return result

def perform_query_2(animals, veterinarians):
    print("Запрос 2: Получить id, вид и название животных, у кого была найдена Адентия и другие похожие заболевания.")
    result_out = animals.where(lambda x: x['id_vet'] == 903).join(veterinarians, lambda key_1: key_1['id_vet'], lambda key_2: key_2['id_vet'])

    for elem in result_out:
        print(elem)
    print()
    return result_out

def perform_query_3(animals):
    print("Запрос 3: Вывести количество животных каждого из возраста.")
    result = animals.group_by(key_names=['age'], key=lambda x: x['age']).select(
        lambda g: {'key': g.key.age, 'quantity': g.count()}).to_list()

    for elem in result:
        print(elem)
    print()

def perform_query_4(animals):
    print("Запрос 4: Вывести минимальный возраст.")
    min_age = animals.min(lambda x: x['age'])

    print(f"Минимальный возраст: {min_age}.\n")

def perform_query_5(animals):
    print("Запрос 5: определить, есть ли в каждой возрастной группе количество животныз, больше 50.")

    groups = animals.group_by(key_names=['age'], key=lambda x: x['age']).select(
        lambda g: { 'key': g.key.age, 'quantity': g.count()})
    result = groups.all(lambda x: x['quantity'] > 50)

    print(f"Результат: {result}\n")

def output_result(result):
    print("{id:5} | {animal_name:10} | {kind:10} | {age:10} | {id_vet:10} | {id_diagnosis:5} | {id_treatment:5}".format(
                                      id="id", animal_name="animal_name", kind="kind", age="age",
                                      id_vet="id_vet", id_diagnosis="id_diagnosis", id_treatment="id_treatment"))
    print('-' * 100)
    for elem in result:
        print("{id:5} | {animal_name:11} | {kind:10} | {age:10} | {id_vet:10} | {id_diagnosis:12} | {id_treatment:10}".format(
                                      id=elem[0], animal_name=elem[1], kind=elem[2], age=elem[3],
                                      id_vet=elem[4], id_diagnosis=elem[5], id_treatment=elem[6]))

