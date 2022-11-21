from random import randint
from constants import *

def read_all_file(PATH):
    with open(PATH, "r", encoding='utf-8') as file_data:
        data = [line.strip() for line in file_data]
    return data

def generate_animals(file_name):
    kinds = read_all_file(PATH_ANIMALS)
    animal_names = read_all_file(PATH_ANIMAL_NAMES)

    with open(file_name, "w", encoding="utf-8") as file_result_database:
        line = 'id, animal_name, kind, age, id_vet, id_diagnosis, id_treatment\n'
        file_result_database.write(line)
        min_kinds = MIN_KINDS - 1; max_kinds = MAX_KINDS - 1
        for i in range(MAX_SIZE_DATABASE):
            id = i+1
            kind = kinds[randint(min_kinds, max_kinds)]
            age = randint(YOUNGEST_ANIMAL, OLDEST_ANIMAL)
            id_vet = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)
            id_diagnosis = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)
            id_treatment = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)

            line = "{0},{1},{2},{3},{4},{5},{6}\n".format(id, animal_names[i], kind, age,
                                                id_vet, id_diagnosis, id_treatment)
            file_result_database.write(line)