import codecs

class Animals():
    '''
    Класс животных, структура которого соответствует таблице animals
    '''
    id = int()
    animal_name = str()
    kind = str()
    age = int()
    id_owner = int()
    id_vet = int()
    id_diagnosis = int()
    id_treatment = int()

    def __init__(self, id:int, animal_name:str, kind:str, age:int, id_owner:int, id_vet:int, id_diagnosis:int, id_treatment:int):
        self.id = id
        self.animal_name = animal_name
        self.kind = kind
        self.age = age
        self.id_owner = id_owner
        self.id_vet = id_vet
        self.id_diagnosis = id_diagnosis
        self.id_treatment = id_treatment

    def get(self):
        return {'id': self.id, 'animal_name': self.animal_name, 'kind': self.kind,
                'age': self.age, 'id_owner': self.id_owner, 'id_vet': self.id_vet, 'id_diagnosis': self.id_diagnosis,
                'id_treatment': self.id_treatment}



def import_animals(file_name):
    animals = list()
    with codecs.open(file_name, mode='r', encoding='utf-8') as file:    
        for line in file:
            row_file = line.split(';')
            row_file[0] = int(row_file[0])
            row_file[3] = int(row_file[3])
            row_file[4] = int(row_file[4])
            row_file[5] = int(row_file[5])
            row_file[6] = int(row_file[6])
            row_file[7] = int(row_file[7])
            animals.append(Animals(*row_file).get())

    return animals