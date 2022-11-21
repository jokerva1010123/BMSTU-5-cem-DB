from constants import *
from paths import *
from random import randint
import datetime
import codecs

def generate_veterinarians():
    surnames = read_all_file(PATH_VETS)
    qualifications = read_all_file(PATH_QUALIFICATIONS)

    file_result_database = open(PATH_VETS_DATABASE, "w", encoding="utf-8")
    lowest_category = LOWEST_CATEGORY - 1
    highest_category = HIGHEST_CATEGORY - 1
    for i in range(MAX_SIZE_DATABASE):
        id = i+1
        age = randint(YOUNGEST_VET, OLDEST_VET)
        cabinet = randint(LOWEST_CABINET, UPPEST_CABINET)
        qualification = qualifications[randint(lowest_category, highest_category)]

        line = "{0};{1};{2};{3};{4}\n".format(id, surnames[i], age, qualification, cabinet)
        file_result_database.write(line)
    file_result_database.close()        

def generate_treatments():
    names = read_all_file(PATH_TREATMENTS)

    file_result_database = open(PATH_TREATMENTS_DATABASE, "w", encoding="utf-8")
    lowest_cost = LOWEST_COST // 50
    highest_cost = MOST_COST // 50

    first_date = datetime.date(FIRST_DATE[0], FIRST_DATE[1], FIRST_DATE[2])
    last_date = datetime.date(LAST_DATE[0], LAST_DATE[1], LAST_DATE[2])
    count_days = (last_date - first_date).days
    for i in range(MAX_SIZE_DATABASE):
        id = i+1
        hospitalization = NOT_HOSPITALIZATION if randint(0, 1) == 0 else IS_HOSPITALIZATION
        duration = randint(LOWEST_DURATION, MOST_DURATION)
        cost = randint(lowest_cost, highest_cost) * 50
        date_visit = first_date + datetime.timedelta(randint(0, count_days))
        line = "{0};{1};{2};{3};{4};{5}\n".format(id, names[i], hospitalization, duration, cost, date_visit)
        file_result_database.write(line)
    file_result_database.close()    

def generate_animals():
    kinds = read_all_file(PATH_ANIMALS)
    animal_names = read_all_file(PATH_ANIMAL_NAMES)

    file_result_database = open(PATH_ANIMALS_DATABASE, "w", encoding="utf-8")
    min_kinds = MIN_KINDS - 1; max_kinds = MAX_KINDS - 1
    for i in range(MAX_SIZE_DATABASE):
        id = i+1
        kind = kinds[randint(min_kinds, max_kinds)]
        age = randint(YOUNGEST_ANIMAL, OLDEST_ANIMAL)
        id_vet = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)
        id_diagnosis = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)
        id_treatment = randint(MIN_SIZE_DATABASE, MAX_SIZE_DATABASE)

        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(id, animal_names[i], kind, age,
                                              id_vet, id_diagnosis, id_treatment)
        file_result_database.write(line)
    file_result_database.close() 

def generate_diagnosises():
    diagnosises = read_all_file(PATH_DIAGNOSISES)

    first_date = datetime.date(FIRST_DATE[0], FIRST_DATE[1], FIRST_DATE[2])
    last_date = datetime.date(LAST_DATE[0], LAST_DATE[1], LAST_DATE[2])
    count_days = (last_date - first_date).days

    file_result_database = open(PATH_DIAGNOSISES_DATABASE, "w", encoding="utf-8")
    min_severity = MIN_SEVERITY - 1; max_severity = MAX_SEVERITY - 1
    for i in range(MAX_SIZE_DATABASE):
        id = i+1
        date_visit = first_date + datetime.timedelta(randint(0, count_days))
        severity = randint(min_severity, max_severity)
        degree_severity = LITTLE_SEVERITY_DISEASE if severity == 0 else MIDDLE_SEVERITY_DISEASE \
                           if severity == 1 else HIGH_SEVERITY_DISEASE
        operation = NOT_NEED_OPERATION if severity != 2 else NEED_OPERATION

        line = "{0};{1};{2};{3};{4}\n".format(id, diagnosises[i], date_visit, degree_severity, operation)
        file_result_database.write(line)
    file_result_database.close() 


def read_all_file(PATH):
    with open(PATH, "r", encoding="utf-8") as file_data:
        data = [line.strip() for line in file_data] 
    return data


if __name__ == "__main__":
    generate_veterinarians()
    generate_treatments()
    generate_animals()
    generate_diagnosises()