# from flask import Flask, json, request, redirect, url_for, session, jsonify
# import json
# from flaskext.mysql import MySQL
# import pymysql
# from werkzeug.wrappers import response
# import hashlib as hs
# from flask_cors import CORS as cors



# # Create vars for Flask and MySQL
# app = Flask(__name__)
# cors(app=app)
# sql_var = MySQL()
# app.config['MYSQL_DATABASE_USER'] = 'dataadder'
# app.config['MYSQL_DATABASE_PASSWORD'] = '12345'
# app.config['MYSQL_DATABASE_DB'] = 'test'
# app.config['MYSQL_DATABASE_HOST'] = '34.133.0.108'

# sql_var.init_app(app)
# @app.route("/query1", methods=['GET'])
# def query1():
#     sql_connect = sql_var.connect()
#     cursor = sql_connect.cursor(pymysql.cursors.DictCursor)

#     query = "SELECT DISTINCT genres, avgRuntime FROM Movies JOIN(SELECT AVG(runtimeMinutes) AS avgRuntime, genres FROM Movies m1 GROUP BY m1.genres) as bob using(genres) ORDER BY avgRuntime DESC;"

#     cursor.execute(query)
#     rows = cursor.fetchall()
#     resp = jsonify(data = json.dumps(rows))
#     print(resp)
#     resp.status_code = 200

#     cursor.close()
#     sql_connect.close()

#     return resp