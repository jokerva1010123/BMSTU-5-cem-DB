from peewee import * # type: ignore

con = PostgresqlDatabase(
	database='musicschool',
	user='postgres',
	password='0509',
	host='localhost', 
	port=5432
)

class BaseModel(Model):
    class Meta:
        database = con

class Comoser(BaseModel):
    id = IntegerField(column_name='id')
    fullname = CharField(column_name='fullname')
    gender = CharField(column_name='gender')
    lifeyear = CharField(column_name='lifeyear')
    nationality = CharField(column_name='nationality')

    class Meta:
        table_name = 'sc1.composer'

class Composition(BaseModel):
    id = IntegerField(column_name='id')
    title = CharField(column_name='title')
    tonality = CharField(column_name='amount')
    amount = IntegerField(column_name='amount')
    composerid = CharField(column_name='composerid')

    class Meta:
        table_name = 'sc1.composition'

class Student(BaseModel):
    id = IntegerField(column_name='id')
    fullname = CharField(column_name='fullname')
    gender = CharField(column_name='gender')
    form = IntegerField(column_name='form')
    speciality = CharField(column_name='speciality')
    friend = IntegerField(column_name='friend')

    class Meta:
        table_name = 'sc1.student'

class Teacher(BaseModel):
    id = IntegerField(column_name='id')
    fullname = CharField(column_name='fullname')
    gender = CharField(column_name='gender')
    age = IntegerField(column_name='age')
    education = CharField(column_name='education')

    class Meta:
        table_name = 'sc1.teacher'

class Exam(BaseModel):
    id = IntegerField(column_name='id')
    studentid = ForeignKeyField(Student, backref='studentid')
    teacherid = ForeignKeyField(Teacher, backref='teacherid')
    compositionid = ForeignKeyField(Composition, backref='compositionid')
    mark = IntegerField(column_name='mark')
    date = DateField(column_name='date')

    class Meta:
        table_name = 'sc1.exam'

def q1():
    print('\n1. Однотабличный запрос на выборку')
    query = Student.select().where(Student.form == 5).limit(5).order_by(Student.id)
    print('Запрос: ', query)

    res = query.dicts().execute()
    for elem in res:
        print(elem)

def q2():
    print('\n2. Многотабличный запрос на выборку')
    pass

def q3():
    print('\n3. Три запроса на добавление, изменение, удаление данных в БД')
    pass

def q4():
    print('\n4. Получение доступа к данным, выполняя только хранимую процедуру')
    pass

def task3():
    global con

    q1()
    q2()
    q3()
    q4()

    con.close()