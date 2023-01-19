from peewee import *
from tables import *
import json

from playhouse.shortcuts import model_to_dict, dict_to_model

user_obj = Animals.select().where(Animals.id <= 10).get()
json_data = json.dumps(model_to_dict(user_obj))