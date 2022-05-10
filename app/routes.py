#from curses import ACS_GEQUAL
#from fattempt.app.database import showAd1
from flask import render_template, request, jsonify, json, make_response
from app import app
from app import database as db_helper
from app import db

@app.route("/delete/<int:task_id>", methods=['POST'])
def delete(task_id):
    try:
# db_helper.remove_task_by_id(task_id)
        result = {'success': True, 'response': 'Removed task'}
    except:
        result = {'success': False, 'response': 'Something went wrong'}
    return jsonify(result)

@app.route("/edit/<int:task_id>", methods=['POST'])
def update(task_id):
    data = request.get_json()
    print(data)
    try:
        if "status" in data:
        # db_helper.update_status_entry(task_id, data["status"])
            result = {'success': True, 'response': 'Status Updated'}
        elif "description" in data:
        # db_helper.update_task_entry(task_id, data["description"])
            result = {'success': True, 'response': 'Task Updated'}
        else:
            result = {'success': True, 'response': 'Nothing Updated'}
    except:
        result = {'success': False, 'response': 'Something went wrong'}

    return jsonify(result)

@app.route("/signup", methods=['POST', 'GET'])
def signup():
    data = request.get_json()
    print(data)

    username = data["_username"]
    password = data["_password"]
    email = data["_emailID"]
    age = data["_age"] 
    gender = data ["_gender"]

    ageint = int(age)

    resp = db_helper.add_user(username, password, email, ageint, gender)
    return make_response(jsonify(data=resp), 200)

@app.route("/")
def homepage():
    items = db_helper.search_movie("Chinese Opium Den")
    return render_template("index.html", items=items)


@app.route("/updatepassword", methods=['POST'])
def updatepassword():
    data = request.get_json()
    print(data)

    username = data["_username"]
    newpassword = data["_newpassword"]
    oldpassowrd = data["_oldpassword"]
    

    db_helper.update_pass(username, newpassword)
    return 'OK'


@app.route("/deleteaccount", methods=['POST'])
def deleteaccount():
    data = request.get_json()

    username = data["_username"]
    password = data["_password"]
    email = data["_emailID"]
    
    db_helper.removeacc(username)
    return 'OK'

@app.route("/query1", methods=['GET'])
def query1():
    resp = db_helper.showAd1()
    # print(resp[0])
    # print("rtpy result")
    # print(str(resp))    
    return make_response(jsonify(data=resp), 200)


@app.route("/search/<movieName>", methods=['GET'])
def search(movieName):
    print('hello')
    resp = db_helper.showSearch(movieName)

    return make_response(jsonify(data=resp), 200)

@app.route("/showrecommended/<userName>", methods=['GET'])
def showrecommended(userName):

    resp = db_helper.showrec(userName)

    return make_response(jsonify(data=resp), 200)


@app.route("/towatch/<userName>", methods=['GET'])
def towatch(userName):

    resp = db_helper.twowatch(userName)

    return make_response(jsonify(data=resp), 200)

@app.route("/alreadywatched/<userName>", methods=['GET'])
def alreadywatched(userName):

    resp = db_helper.dejawatched(userName)

    return make_response(jsonify(data=resp), 200)

@app.route("/addtowatchlist", methods=['POST', 'GET'])
def addtowatchlist():
    data = request.get_json()
    print(data)

    username = data["_username"]
    movieName = data["_movieName"]

    resp = db_helper.addMovieToWatchList(username, movieName)
    return make_response(jsonify(data=resp), 200)



@app.route("/addtoalreadywatchedlist", methods=['POST', 'GET'])
def addtoalreadywatchedlist():
    data = request.get_json()
    print(data)

    username = data["_username"]
    movieName = data["_movieName"]

    resp = db_helper.addMovieToWatchedList(username, movieName)
    return make_response(jsonify(data=resp), 200)


@app.route("/showpopmovies", methods=['GET'])
def showpopmovies():
    resp = db_helper.popmovies()
    return make_response(jsonify(data=resp), 200)

@app.route("/showpoptv", methods=['GET'])
def showpoptv():
    resp = db_helper.poptv()
    return make_response(jsonify(data=resp), 200)

@app.route("/filtergenre", methods=['POST'])
def filtergenre():
    data = request.get_json()
    username = data["_username"]
    genre = data["_genre"]    
    db_helper.filtergenrehelp(username, genre)
    return 'OK'

#filterbyactorscreen
@app.route("/filterbyactorscreen", methods=['POST'])
def filterbyactorscreen():
    data = request.get_json()
    username = data["_username"]
    actorname = data["_actorname"]    
    db_helper.filteractorhelp(username, actorname)
    return 'OK'