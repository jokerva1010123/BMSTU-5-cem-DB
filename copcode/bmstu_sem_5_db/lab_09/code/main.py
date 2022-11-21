import redis
import psycopg2, json
import time
import matplotlib.pyplot as plt
import numpy as np

def select_request_db(connection):
    cursor = connection.cursor()
    time_start = time.time()
    cursor.execute("""
                    select animals.id, animals.animal_name, treatments.cost
                    from animals join treatments on animals.id_treatment = treatments.id_treatment
                    group by animals.id, animals.animal_name, treatments.cost
                    order by treatments.cost desc
                   """)
    result = cursor.fetchall()
    time_end = time.time()
    diff_time = time_end - time_start
    #print(f"Время выполнения запроса БД: {diff_time}")
    cursor.close()
    return diff_time, result

def select_request_redis(connection, redis_client):
    cursor = connection.cursor()

    time_start = time.time()
    cache_value = redis_client.get("request")
    if cache_value is None:
        cursor.execute("""
                    select animals.id, animals.animal_name, treatments.cost
                    from animals join treatments on animals.id_treatment = treatments.id_treatment
                    group by animals.id, animals.animal_name, treatments.cost
                    order by treatments.cost desc
                   """)
        result = cursor.fetchall()
        redis_client.set("request", str(result), ex=6)
        cache_value = redis_client.get("request")
    time_end = time.time()
    diff_time = time_end - time_start
    cursor.close()
    #print(f"Время выполнения запроса Redis: {diff_time}")
    return diff_time, cache_value

def insert_request_db(connection):
    cursor = connection.cursor()
    time_start = time.time()
    cursor.execute("""insert into animals(id, animal_name, kind, age, id_vet, id_diagnosis, id_treatment)
                    values(1010, 'Арни', 'redis_kind', 15, 645, 931, 145)""")
    time_end = time.time()
    diff_time = time_end - time_start

    cursor.execute("""
                    select *
                    from animals
                    where kind = 'redis_kind'
                  """)
    result = cursor.fetchall()                    
    connection.commit()
    cursor.close()
    return diff_time, result

def update_request_db(connection):
    cursor = connection.cursor()
    time_start = time.time()
    cursor.execute("""
                    update animals
                    set kind = 'Редиска'
                    where kind = (select kind
                                           from animals
                                           where kind = 'redis_kind')
                   """)
    time_end = time.time()
    diff_time = time_end - time_start 

    cursor.execute("""
                    select *
                    from animals
                    where kind = 'redis_kind'
                  """)
    result = cursor.fetchall()  
    connection.commit()
    cursor.close()
    return diff_time, result

def delete_request_db(connection):
    cursor = connection.cursor()
    time_start = time.time()
    cursor.execute("""
                    delete
                    from animals
                    where kind = 'Редиска'
                   """)
    time_end = time.time()
    diff_time = time_end - time_start 
    connection.commit()
    cursor.close()
    return diff_time

def insert_request_redis(redis_client, result):
    time_start = time.time()
    redis_client.set("insert", str(result))
    time_end = time.time()
    diff_time = time_end - time_start
    return diff_time

def update_request_redis(redis_client, result):
    time_start = time.time()
    redis_client.set("insert", str(result))
    time_end = time.time()
    diff_time = time_end - time_start
    return diff_time

def delete_request_redis(redis_client):
    time_start = time.time()
    redis_client.delete("insert")
    time_end = time.time()
    diff_time = time_end - time_start
    return diff_time

def output_db_result(result):
    print(f"Данные, полученные из БД:")
    for row in result:
        print(row)

def output_redis_result(cache_value):
    print(f"Данные, полученные из Redis:\n{cache_value.decode()}")

def main():
    time_db = []; time_redis = []
    
    try:
        connection = psycopg2.connect(
                database = "postgres",
                user = "postgres",
                password = "Deadly_Hunter_38",
                host="127.0.0.1",
                port="5432"	
        )

        redis_client = redis.Redis(host='127.0.0.1', port=6379)
    except:
        print("Ошибка при подключении к БД")
        return

    time_select_db = list(); time_select_redis = list()
    time_insert_db = list(); time_insert_redis = list() 
    time_update_db = list(); time_update_redis = list() 
    time_delete_db = list(); time_delete_redis = list()  

    print(f"Программа выполняется. Ожидайте.")

    minutes_wait = 0.5
    count_iterations = int(minutes_wait * 60) // 5

    for i in range(count_iterations):
        print(f"i = {i}")
        average_time_select_db = 0; average_time_select_redis = 0
        average_time_insert_db = 0; average_time_insert_redis = 0
        average_time_update_db = 0; average_time_update_redis = 0
        average_time_delete_db = 0; average_time_delete_redis = 0

        diff_time_db, result = select_request_db(connection)
        diff_time_redis, cache_value = select_request_redis(connection, redis_client)

        average_time_select_db += diff_time_db
        average_time_select_redis += diff_time_redis

        time_select_db.append(0); time_select_redis.append(0)
        time_select_db.append(average_time_select_db); time_select_redis.append(average_time_select_redis)
        time_select_db.append(0); time_select_redis.append(0)

        print(f"Среднее время работы обращения к БД: {average_time_select_db}")
        print(f"Среднее время работы обращения к Redis: {average_time_select_redis}")
        
        '''
        if i % 2:
            for j in range(1000):
                diff_time_db, result = select_request_db(connection)
                diff_time_redis, cache_value = select_request_redis(redis_client, result)

                diff_time_db, result = insert_request_db(connection)
                average_time_insert_db += diff_time_db

                diff_time_db, result = update_request_db(connection)
                average_time_update_db += diff_time_db
            
                average_time_delete_db += delete_request_db(connection)  

                average_time_insert_redis += insert_request_redis(redis_client, result)
                average_time_update_redis += update_request_redis(redis_client, result)
                average_time_delete_redis += delete_request_redis(redis_client)

            average_time_insert_db /= 1000; average_time_update_db /= 1000; average_time_delete_db /= 1000 
            average_time_insert_redis /= 1000; average_time_update_redis /= 1000; average_time_delete_redis /= 1000   

            print(f"Среднее время работы insert БД: {average_time_insert_db}")
            print(f"Среднее время работы update БД: {average_time_update_db}")
            print(f"Среднее время работы delete БД: {average_time_delete_db}")

            print(f"Среднее время работы insert Redis: {average_time_insert_redis}")
            print(f"Среднее время работы update Redis: {average_time_update_redis}")
            print(f"Среднее время работы delete Redis: {average_time_delete_redis}")
            
            time_insert_db.append(0); time_insert_redis.append(0)
            time_insert_db.append(average_time_insert_db + average_time_select_db)
            time_insert_redis.append(average_time_insert_redis + average_time_select_redis)
            time_insert_db.append(0); time_insert_redis.append(0)

            time_update_db.append(0); time_update_redis.append(0)
            time_update_db.append(average_time_update_db + average_time_select_db)
            time_update_redis.append(average_time_update_redis + average_time_select_redis)
            time_update_db.append(0); time_update_redis.append(0)

            time_delete_db.append(0); time_delete_redis.append(0)
            time_delete_db.append(average_time_delete_db + average_time_select_db)
            time_delete_redis.append(average_time_delete_redis + average_time_select_redis)
            time_delete_db.append(0); time_delete_redis.append(0)
        '''
        time.sleep(5)

    #output_db_result(result)
    #output_redis_result(cache_value)

    redis_client.close()
    connection.close()

    dx = 0.5
    x_select = []
    for t in range(count_iterations):
        x_select.append(t * 5 - dx)
        x_select.append(t * 5)
        x_select.append(t * 5 + dx)
    '''
    x_others = []
    for t in range(count_iterations // 2):
        x_others.append(t * 10 - dx)
        x_others.append(t * 10)
        x_others.append(t * 10 + dx)
    '''    
    plt.plot(x_select, time_select_db, label='Request to Postgres (select)')
    plt.plot(x_select, time_select_redis, label='Request to Redis (select)')
    plt.legend(loc='upper right')
    plt.show()

    '''
    plt.plot(x_others, time_insert_db, label='Request to Postgres (select+insert)')
    plt.plot(x_others, time_insert_redis, label='Request to Redis (select+insert)')
    plt.legend(loc='upper right')
    plt.show()

    plt.plot(x_others, time_update_db, label='Request to Postgres (select+update)')
    plt.plot(x_others, time_update_redis, label='Request to Redis (select+update)')
    plt.legend(loc='upper right')
    plt.show()

    plt.plot(x_others, time_delete_db, label='Request to Postgres (select+delete)')
    plt.plot(x_others, time_delete_redis, label='Request to Redis (select+delete)')
    plt.legend(loc='upper right')
    plt.show()'''

if __name__ == "__main__":
    main()
    
