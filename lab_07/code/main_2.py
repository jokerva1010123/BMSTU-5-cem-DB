<<<<<<< HEAD
from peewee import *
from tables import *
import json

from playhouse.shortcuts import model_to_dict, dict_to_model

user_obj = Animals.select().where(Animals.id <= 10).get()
=======
from peewee import *
from tables import *
import json

from playhouse.shortcuts import model_to_dict, dict_to_model

user_obj = Animals.select().where(Animals.id <= 10).get()
>>>>>>> 6a1432358f78568cbef2fb6ac12b2d861fa1affd
json_data = json.dumps(model_to_dict(user_obj))