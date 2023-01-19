<<<<<<< HEAD
from peewee import *

connect = PostgresqlDatabase(database='postgres',
                                user='postgres',
                                password='0612',
                                host='localhost', 
                                port=5432
                            )

class BaseModel(Model):
	class Meta:
		database = connect

class Veterinarians(BaseModel):
    id = IntegerField(column_name="id_vet")
    surname = CharField(column_name='surname')
    age = IntegerField(column_name='age')
    qualification = CharField(column_name='qualification')
    cabinet = IntegerField(column_name='cabinet')
    
    class Meta:
        table_name = 'veterinarian'

class Treatments(BaseModel):
    id = IntegerField(column_name='id_treatment')
    treatment_name = CharField(column_name='treatment_name')
    hospitalization = CharField(column_name='hospitalization')
    duration = IntegerField(column_name='duration')
    cost = IntegerField(column_name='cost')
    date = DateField(column_name='date')
    
    class Meta:
        table_name = 'treatment'


class Diagnoses(BaseModel):
    id = IntegerField(column_name='id_diagnosis')
    name = CharField(column_name='name')
    date = DateField(column_name='date')
    degree_severity = CharField(column_name='degree_severity')
    need_operation = CharField(column_name='need_operation')
    
    class Meta:
        table_name = 'diagnosis'

class Animals(BaseModel):
    id = IntegerField(column_name='id')
    animal_name = CharField(column_name='animal_name')
    kind = CharField(column_name='kind')
    age = IntegerField(column_name='age')
    id_onwer = IntegerField(column_name='id_owner')
    id_vet = ForeignKeyField(Veterinarians, column_name='id_vet')
    id_diagnosis = ForeignKeyField(Diagnoses, column_name='id_diagnosis')
    id_treatment = ForeignKeyField(Treatments, column_name='id_treatment')
    
    class Meta:
=======
from peewee import *

connect = PostgresqlDatabase(database='postgres',
                                user='postgres',
                                password='0612',
                                host='localhost', 
                                port=5432
                            )

class BaseModel(Model):
	class Meta:
		database = connect

class Veterinarians(BaseModel):
    id = IntegerField(column_name="id_vet")
    surname = CharField(column_name='surname')
    age = IntegerField(column_name='age')
    qualification = CharField(column_name='qualification')
    cabinet = IntegerField(column_name='cabinet')
    
    class Meta:
        table_name = 'veterinarian'

class Treatments(BaseModel):
    id = IntegerField(column_name='id_treatment')
    treatment_name = CharField(column_name='treatment_name')
    hospitalization = CharField(column_name='hospitalization')
    duration = IntegerField(column_name='duration')
    cost = IntegerField(column_name='cost')
    date = DateField(column_name='date')
    
    class Meta:
        table_name = 'treatment'


class Diagnoses(BaseModel):
    id = IntegerField(column_name='id_diagnosis')
    name = CharField(column_name='name')
    date = DateField(column_name='date')
    degree_severity = CharField(column_name='degree_severity')
    need_operation = CharField(column_name='need_operation')
    
    class Meta:
        table_name = 'diagnosis'

class Animals(BaseModel):
    id = IntegerField(column_name='id')
    animal_name = CharField(column_name='animal_name')
    kind = CharField(column_name='kind')
    age = IntegerField(column_name='age')
    id_onwer = IntegerField(column_name='id_owner')
    id_vet = ForeignKeyField(Veterinarians, column_name='id_vet')
    id_diagnosis = ForeignKeyField(Diagnoses, column_name='id_diagnosis')
    id_treatment = ForeignKeyField(Treatments, column_name='id_treatment')
    
    class Meta:
>>>>>>> 6a1432358f78568cbef2fb6ac12b2d861fa1affd
        table_name = 'animals'