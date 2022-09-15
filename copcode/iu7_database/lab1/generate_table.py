#! /usr/bin/env python
# -*- coding: utf-8 -*-

import random

def rand(min_count, max_count):
    return random.randint(min_count, max_count)

def client():
    customers = []
    woman_name = ['Ekaterina', 'Elena', 'Elina', 'Galina', 'Elvira', 'Valentina', 'Valeria', 'Vasilisa', 'Vera', 'Veronica',
                  'Lada', 'Lana', 'Larisa', 'Lena', 'Sonia', 'Sophia', 'Stanislava', 'Stefania', 'Katya', 'Kira']
    woman_surname = ['Ivanova','Smirnova','Kuznecova','Popova','Vasileva','Petrova','Sokolova','Mikhailova'
        ,'Novikova','Fedorova','Morozova','Volkova','Alekseeva','Lebedeva','Semenova','Egorova','Pavlova'
        ,'Kozlova','Stepanova','Nikolaeva']
    man_name = ['Alexey','Artem','Vadim','Vladimir','Valentin','Danil','Denis','Dmitri','Egor','Kirill','Leonid',
                'Maxim','Matvei','Nikita','Oleg','Pavel','Petr','Roman','Sergei','Slava']
    man_surname = ['Ivanov','Smirnov','Kuznecov','Popov','Vasilev','Petrov','Sokolov','Mikhailov'
        ,'Novikov','Fedorov','Morozov','Volkov','Alekseev','Lebedev','Semenov','Egorov','Pavlov'
        ,'Kozlov','Stepanov','Nikolaev']
    for i in range(120):
        customers.append([])
        if i%2 == 0:
            customers[i].append(random.choice(woman_name))
            customers[i].append(random.choice(woman_surname))
        else:
            customers[i].append(random.choice(man_name))
            customers[i].append(random.choice(man_surname))

    client_file = open('client_table.txt', 'w')
    client_file.write("id Клиента,Имя,Фамилия,Номер телефона, Возраст\n")
    len_array_client = len(customers)
    for i in range(len_array_client):
        if i%3 == 0:
            number = '8925'
        elif i%3 == 1:
            number = '8916'
        else:
            number = '8985'
        number += str(rand(1136482, 9999999))
        client_file.write(str(i+1) + ',' + customers[i][0] + ',' + customers[i][1] + ',' + number + ',' + str(rand(15, 40)) + '\n')

def platform():
    platform_table = open('platform_table.txt', 'w')
    platform_table.write("id Платформы,Название,Разработчик,Год выхода\n")
    for i in range(len_array_platform):
        platform_table.write(str(i+1) + ',' + array_platform[i][0] + ',' + array_platform[i][1] + ',' +
                             str(rand(2008, 2020)) + '\n')

def developer():
    country = ['Austria','Belgiua','Denmark','Finland','France','Germany','Ireland','Italy','Netherlands'
    ,'Norway','Russia','Spain','Sweden','Switzerland','United Kingdom','Israel', 'Japan', 'South Korea', 
     'Canada', 'United States']
    developer_table = open('developer_table.txt', 'w')
    developer_table.write("id Разработчика,Название организации,Местоположение\n")
    len_array_country = len(country)
    for i in range(len_array_game):
        developer_table.write(str(i+1) + ',' + array_game[i][1] + ',' + country[rand(0, len_array_country-1)] + '\n')


client()

game_file = open('game.txt', 'r')
genre_file = open('genre.txt', 'r')
platform_file = open('platform.txt', 'r')
client_file = open('client_table.txt',)

array_game = [line.strip() for line in game_file]
array_game = [line.split(',') for line in array_game]
len_array_game = len(array_game)

array_genre = [line.strip() for line in genre_file]
len_array_genre = len(array_genre)

len_client_file = 0
for line in client_file:
    len_client_file += 1

array_platform = [line.strip() for line in platform_file]
array_platform = [line.split(',') for line in array_platform]
len_array_platform = len(array_platform)

platform()
developer()


game_table = open('game_table.txt', 'w')
game_table.write("id Игры,Название,Жанр,id Разработчика,id Платформы,Год выпуска,Цена,id Клиента\n")
for i in range(len_array_game):
    game_table.write(str(i+1) + ',' + array_game[i][0] + ',' + str(array_genre[rand(0, len_array_genre-1)]) + ','
                     + str(rand(1, len_array_game)) + ',' + str(rand(1, len_array_platform)) + ',' +
                     str(rand(2014, 2021)) + ',' + str(rand(1000, 5000)) + ',' + str(rand(1, len_client_file)) + '\n')
