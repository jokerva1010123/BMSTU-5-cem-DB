import datetime as dt
import mimesis as mem
import random as rand
import csv

def csv_writer(data, path):
    with open(path, "a", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        for line in data:
            writer.writerow(line)
            
pers = mem.Person('ru')
prop = [mem.enums.Gender.MALE, mem.enums.Gender.FEMALE]
gender = ['муж', 'жен']
for i in range(1200):
    who = rand.randint(0, 1)
    y = rand.randint(2013, 2018)
    m = rand.randint(1, 12)
    d = rand.randint(1, 28)
    fk = rand.randint(1, 100)
    values = [(i+1, pers.full_name(prop[who]), dt.date(y, m, d), gender[who], fk)]
    path = "child.csv"
    csv_writer(values, path)
