<<<<<<< HEAD
import codecs

class Vets():
    '''
    Класс ветеринаров, структура которого соответствует таблице veterinarians
    '''
    id_vet = int()
    surname = str()
    age = int()
    qualification = str()
    cabinet = int()

    def __init__(self, id_vet:int, surname:str, age:int, qualification:str, cabinet:int):
        self.id_vet = id_vet
        self.surname = surname
        self.age = age
        self.qualification = qualification
        self.cabinet = cabinet

    def get(self):
        return {'id_vet': self.id_vet, 'surname': self.surname, 'age': self.age,
                'qualification': self.qualification, 'cabinet': self.cabinet}

def import_vets(file_name):
    vets = list()
    with codecs.open(file_name, mode='r', encoding='utf-8') as file:    
        for line in file:
            row_file = line.split(';')
            row_file[0] = int(row_file[0])
            row_file[3] = int(row_file[2])
            row_file[4] = int(row_file[4])

            vets.append(Vets(*row_file).get())

=======
import codecs

class Vets():
    '''
    Класс ветеринаров, структура которого соответствует таблице veterinarians
    '''
    id_vet = int()
    surname = str()
    age = int()
    qualification = str()
    cabinet = int()

    def __init__(self, id_vet:int, surname:str, age:int, qualification:str, cabinet:int):
        self.id_vet = id_vet
        self.surname = surname
        self.age = age
        self.qualification = qualification
        self.cabinet = cabinet

    def get(self):
        return {'id_vet': self.id_vet, 'surname': self.surname, 'age': self.age,
                'qualification': self.qualification, 'cabinet': self.cabinet}

def import_vets(file_name):
    vets = list()
    with codecs.open(file_name, mode='r', encoding='utf-8') as file:    
        for line in file:
            row_file = line.split(';')
            row_file[0] = int(row_file[0])
            row_file[3] = int(row_file[2])
            row_file[4] = int(row_file[4])

            vets.append(Vets(*row_file).get())

>>>>>>> 6a1432358f78568cbef2fb6ac12b2d861fa1affd
    return vets