<<<<<<< HEAD
from peewee import *
from tables import *

def query_1():
    print("Однотабличный запрос на выборку")

    query = Animals.select().where(Animals.kind == "Собака")
    print("Запрос на выбору всех собак.")
    print(query)

    animal = query.dicts().execute()
    for elem in animal:
        print(elem)

def query_2():
    print("Многотабличный запрос на выборку.\т" +
          "Вывести информацио о лечащих врачах первых десяти в списке животных.")

    query = Animals.select(Animals.id, Animals.animal_name, Veterinarians.surname).join(
                            Veterinarians, on=(Animals.id_vet == Veterinarians.id)).limit(10)
    print(query)
    animal = query.dicts().execute()
    for elem in animal:
        print(elem)
    pass

def add_elem(new_id, new_animal_name, new_kind, new_age, new_id_vet, new_id_diagnosis, new_id_treatment):
    global con 
	
    try:
        with connect.atomic() as txn:
            # user = Users.get(Users.id == new_id)
            Animals.create(id=new_id, animal_name=new_animal_name, kind=new_kind, age=new_age, id_vet=new_id_vet, 
                        id_diagnosis=new_id_diagnosis, id_treatment=new_id_treatment)
            print("Пользователь успешно добавлен!")
    except:
        print("Пользователь уже существует!")
        txn.rollback()

def update_elem(animal_id, new_animal_name):
    animal = Animals(id=animal_id)
    animal.animal_name = new_animal_name
    animal.save()
    print("Имя животного успешно обновлено!")
    pass

def delete_elem(animal_id):
    user = Animals.get(Animals.id == animal_id)
    user.delete_instance()
    print("Животное успешно удалено!")

def print_elems():
    print("Последние 10 записей в таблице:")
    query = Animals.select().limit(10).order_by(Animals.id.desc())

    print(query)
    vets = query.dicts().execute()
    for elem in vets:
        print(elem)

def print_vets():
    print("Последние 10 записей в таблице:")
    query = Veterinarians.select().limit(10).order_by(Veterinarians.id.desc())

    print(query)
    vets = query.dicts().execute()
    for elem in vets:
        print(elem)

def query_3():
    print("Три запроса на добавление, изменение, удаление данных в БД.")
    print_elems()

    add_elem(1010, 'Буч', 'Собака', 13, 555, 142, 384)
    print_elems()

    update_elem(1010, "Персик")
    print_elems()

    delete_elem(1010)
    print_elems()    

def query_4():
    print("Получение доступа к данным, выполняя только хранимую процедуру")

    print("Таблица с последними 10-ю записями до вызова:")
    print_vets()
    cursor = connect.cursor()
    cursor.execute("call update_vet_post('Щербина');")
    connect.commit()

    print("Таблица с последними 10-ю записями после вызова:")
    print_vets()
    cursor.close()

    pass

def do_task_3():
    global connect

    query_1()
    query_2()
    query_3()
    query_4()

    connect.close()
    
    pass

=======
from peewee import *
from tables import *

def query_1():
    print("Однотабличный запрос на выборку")

    query = Animals.select().where(Animals.kind == "Собака")
    print("Запрос на выбору всех собак.")
    print(query)

    animal = query.dicts().execute()
    for elem in animal:
        print(elem)

def query_2():
    print("Многотабличный запрос на выборку.\т" +
          "Вывести информацио о лечащих врачах первых десяти в списке животных.")

    query = Animals.select(Animals.id, Animals.animal_name, Veterinarians.surname).join(
                            Veterinarians, on=(Animals.id_vet == Veterinarians.id)).limit(10)
    print(query)
    animal = query.dicts().execute()
    for elem in animal:
        print(elem)
    pass

def add_elem(new_id, new_animal_name, new_kind, new_age, new_id_vet, new_id_diagnosis, new_id_treatment):
    global con 
	
    try:
        with connect.atomic() as txn:
            # user = Users.get(Users.id == new_id)
            Animals.create(id=new_id, animal_name=new_animal_name, kind=new_kind, age=new_age, id_vet=new_id_vet, 
                        id_diagnosis=new_id_diagnosis, id_treatment=new_id_treatment)
            print("Пользователь успешно добавлен!")
    except:
        print("Пользователь уже существует!")
        txn.rollback()

def update_elem(animal_id, new_animal_name):
    animal = Animals(id=animal_id)
    animal.animal_name = new_animal_name
    animal.save()
    print("Имя животного успешно обновлено!")
    pass

def delete_elem(animal_id):
    user = Animals.get(Animals.id == animal_id)
    user.delete_instance()
    print("Животное успешно удалено!")

def print_elems():
    print("Последние 10 записей в таблице:")
    query = Animals.select().limit(10).order_by(Animals.id.desc())

    print(query)
    vets = query.dicts().execute()
    for elem in vets:
        print(elem)

def print_vets():
    print("Последние 10 записей в таблице:")
    query = Veterinarians.select().limit(10).order_by(Veterinarians.id.desc())

    print(query)
    vets = query.dicts().execute()
    for elem in vets:
        print(elem)

def query_3():
    print("Три запроса на добавление, изменение, удаление данных в БД.")
    print_elems()

    add_elem(1010, 'Буч', 'Собака', 13, 555, 142, 384)
    print_elems()

    update_elem(1010, "Персик")
    print_elems()

    delete_elem(1010)
    print_elems()    

def query_4():
    print("Получение доступа к данным, выполняя только хранимую процедуру")

    print("Таблица с последними 10-ю записями до вызова:")
    print_vets()
    cursor = connect.cursor()
    cursor.execute("call update_vet_post('Щербина');")
    connect.commit()

    print("Таблица с последними 10-ю записями после вызова:")
    print_vets()
    cursor.close()

    pass

def do_task_3():
    global connect

    query_1()
    query_2()
    query_3()
    query_4()

    connect.close()
    
    pass

>>>>>>> 6a1432358f78568cbef2fb6ac12b2d861fa1affd
#