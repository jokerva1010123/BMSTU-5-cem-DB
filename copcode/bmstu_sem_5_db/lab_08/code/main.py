import sys
import time
from datetime import datetime

from generator import *

def output_is_generated(file_name_out: str):
    print(f'Файл с именем "{file_name_out}" сгенерирован. Ожидаем новый.')

if __name__ == "__main__":
    for i in range(len(sys.argv)):
        print(sys.argv[i])

    if len(sys.argv) != 3:
        print("Неверное число аргументов командной строки (должно быть три: имя программы, имя файла, время задержки).")
        sys.exit(-1)
    
    file_name_in = sys.argv[1]
    wait_time_in = int(sys.argv[2])

    i = 0
    while True:
        #замена в имени пути знаков '-', ' ', ':'
        file_name_out = 'C:\\msys64\\home\\Лев\\bmstu_sem_5_db\\lab_08\\data\\' + (str(i) + '_' + file_name_in + '_' + str(datetime.now())[:-7] + '.csv').replace('-', '_').replace(' ', '_').replace(':', '_')
        generate_animals(file_name_out)
        output_is_generated(file_name_out)
        i += 1
        time.sleep(wait_time_in)