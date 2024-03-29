import os
import sqlalchemy
from yaml import load, Loader
from flask import Flask, request, jsonify
#from flaskext.mysql import MySQL

app = Flask(__name__)
#mysql = MySQL()
#app.config['MYSQL_DATABASE_USER'] = 'dataadder'
#app.config['MYSQL_DATABASE_PASSWORD'] = '12345'
#app.config['MYSQL_DATABASE_DB'] = 'test'
#app.config['MYSQL_DATABASE_HOST'] = '34.133.0.108'
#mysql.init_app(app)

def init_connect_engine():
    if os.environ.get('GAE_ENV') != 'standard':
        variables = load(open("app.yaml"), Loader=Loader)
        env_variables = variables['env_variables']
        for var in env_variables:
            os.environ[var] = env_variables[var]
    pool = sqlalchemy.create_engine(
        sqlalchemy.engine.url.URL(
            drivername="mysql+pymysql",
            username=os.environ.get('MYSQL_USER'), #username
            password=os.environ.get('MYSQL_PASSWORD'), #user password
            database=os.environ.get('MYSQL_DB'), #database name
            host=os.environ.get('MYSQL_HOST') #ip
        )
    )
    return pool

app = Flask(__name__)
db = init_connect_engine()

from app import routes