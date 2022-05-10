from sqlite3 import Row
from app import db
from sqlalchemy import text, exc
from flask import render_template, request, jsonify, make_response
import json

def search_movie(text : str) -> dict:
    conn = db.connect()
    query = 'SELECT * FROM Movies WHERE title = "{}";'.format(text)
    query_results = conn.execute(query).fetchall()
    conn.close()
    todo_list = []
    for result in query_results:
        item = {
            "id": result[0],
            "title": result[1],
            "genre": result[2],
            "rating": result[3]
        }
    
    todo_list.append(item)
    return todo_list

def update_task_entry(task_id: int, text: str) -> None:
    conn = db.connect()
    query = 'Update tasks set task = "{}" where id = {};'.format(text, task_id)
    conn.execute(query)
    conn.close()

def add_user(username : str, password : str, email : str,  age : int, gender : str):
    conn = db.connect()
    try:
        query = 'INSERT INTO UserLogin VALUES("{}", "{}", "{}", "{}", "{}");'.format(username, email, password, age, gender)
        conn.execute(query)
        conn.close()
    except exc.OperationalError:
        return_val = []
        curr_json = {}
        curr_json["ErrorCode"] = 69420
        curr_json["UserName"] = username
        return_val.append(json.dumps(curr_json))
        return json.dumps(return_val)
    return_val = []
    curr_json = {}
    curr_json["ErrorCode"] = 200
    curr_json["UserName"] = username
    return_val.append(json.dumps(curr_json))
    return json.dumps(return_val)

def update_pass(username : str, npassword : str) -> None:
    conn = db.connect()
    query = 'UPDATE UserLogin SET pword = "{}" WHERE userName = "{}";'.format(npassword, username)
    conn.execute(query)
    conn.close()

def removeacc(username : str) -> None:
    conn = db.connect()
    query = 'DELETE FROM UserLogin WHERE userName = "{}";'.format(username)
    query2 = 'DELETE FROM UserProfile WHERE UserName = "{}";'.format(username)
    conn.execute(query2)
    conn.execute(query)
    conn.close()

def showAd1():
    conn = db.connect()
    query = 'SELECT DISTINCT genres, avgRuntime FROM Movies JOIN(SELECT AVG(runtimeMinutes) AS avgRuntime, genres FROM Movies m1 GROUP BY m1.genres) as bob using(genres) ORDER BY avgRuntime DESC LIMIT 5;'
    #resultset = conn.execute(query)
    resultset = conn.execute(query).fetchall()
    return_val = []
    for value in resultset:
        curr_json = {}
        curr_json["genre"] = value[0]
        curr_json["avgRuntime"] = str(value[1])
        return_val.append(json.dumps(curr_json))

    #results_as_dict = resultset.mappings().all()
    # mydict = jsonify(data = json.dumps(resultset))
    # print(mydict)
    # print("dbpy result")
    # print(results_as_dict)
    conn.close()
    # print(jsonify(data = jsonify(return_val)))
    #return results_as_dict
    return json.dumps(return_val)

# def showAd2():
#     conn = db.connect()
#     query = '(SELECT genres, COUNT(*) as FREQ FROM Movies m GROUP BY m.genres) UNION (SELECT genres, COUNT(*) as FREQ FROM TV t GROUP BY t.genres);'
#     ret = conn.execute(query)
#     conn.close()
#     return ret

def showSearch(moviename : str):
    conn = db.connect()
    query = 'SELECT * FROM Movies WHERE title = "{}";'.format(moviename)
    resultset = conn.execute(query).fetchall()
    return_val = []
    for value in resultset:
        curr_json = {}
        curr_json["titleID"] = value[0]
        curr_json["title"] = value[1]
        curr_json["genres"] = value[2]
        curr_json["startYear"] = str(value[3])
        curr_json["averageRating"] = str(value[4])
        curr_json["directors"] = value[5]
        curr_json["runtimeMinutes"] = str(value[6])
        curr_json["isAdult"] = str(value[7])
        curr_json["leadRole"] = str(value[8])
        return_val.append(json.dumps(curr_json))
        
    conn.close()
    return json.dumps(return_val)


def showrec(username : str):
    conn = db.connect()
    query = """(SELECT title FROM Movies WHERE titleId IN (
    SELECT EntertainmentId
    FROM RecommendedList 
    WHERE UserId =
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")))
    UNION
    (SELECT title
    FROM TV 
    WHERE titleId IN (
    SELECT EntertainmentId
    FROM RecommendedList 
    WHERE UserId=
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")));""".format(username, username)
    resultset = conn.execute(query).fetchall()
    return_val = []
    for value in resultset:
        curr_json = {}
        curr_json["MovieName"] = value[0]
        return_val.append(json.dumps(curr_json))
        
    conn.close()
    return json.dumps(return_val)



def twowatch(username : str):
    conn = db.connect()
    query = """(SELECT title FROM Movies WHERE titleId IN (
    SELECT EntertainmentId
    FROM ToWatchList 
    WHERE UserId =
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")))
    UNION
    (SELECT title
    FROM TV 
    WHERE titleId IN (
    SELECT EntertainmentId
    FROM ToWatchList 
    WHERE UserId=
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")));""".format(username, username)
    resultset = conn.execute(query).fetchall()
    return_val = []
    for value in resultset:
        curr_json = {}
        curr_json["MovieName"] = value[0]
        return_val.append(json.dumps(curr_json))
        
    conn.close()
    return json.dumps(return_val)

def dejawatched(username : str):
    conn = db.connect()
    query = """(SELECT title FROM Movies WHERE titleId IN (
    SELECT EntertainmentId
    FROM WatchedList 
    WHERE UserId =
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")))
    UNION
    (SELECT title
    FROM TV 
    WHERE titleId IN (
    SELECT EntertainmentId
    FROM WatchedList 
    WHERE UserId=
    (SELECT UserId
    FROM UserProfile
    WHERE UserName = "{}")));""".format(username, username)
    resultset = conn.execute(query).fetchall()
    return_val = []
    for value in resultset:
        curr_json = {}
        curr_json["MovieName"] = value[0]
        return_val.append(json.dumps(curr_json))
        
    conn.close()
    return json.dumps(return_val)

def addMovieToWatchList(username : str, movieName : str):
    conn = db.connect()
    try:
        query = 'INSERT INTO ToWatchList(UserId, EntertainmentId) VALUES((SELECT UserId FROM UserProfile WHERE UserName = "{}"), (SELECT titleId FROM Movies WHERE title = "{}"));'.format(username, movieName)
        conn.execute(query)
        conn.close()
    except exc.OperationalError:
        return_val = []
        curr_json = {}
        curr_json["ErrorCode"] = 69420
        curr_json["UserName"] = username
        return_val.append(json.dumps(curr_json))
        return json.dumps(return_val)
    return_val = []
    curr_json = {}
    curr_json["ErrorCode"] = 200
    curr_json["UserName"] = username
    return_val.append(json.dumps(curr_json))
    return json.dumps(return_val)



def addMovieToWatchedList(username : str, movieName : str):
    conn = db.connect()
    try:
        query1 = 'INSERT INTO WatchedList(UserId, EntertainmentId) VALUES((SELECT UserId FROM UserProfile WHERE UserName = "{}"), (SELECT titleId FROM Movies WHERE title = "{}"));'.format(username, movieName)
        query2 = 'DELETE FROM ToWatchList WHERE (UserId = (SELECT UserId FROM UserProfile WHERE UserName = "{}") AND EntertainmentId = (SELECT titleId FROM Movies WHERE title = "{}"));'.format(username, movieName)
        conn.execute(query1)
        conn.execute(query2)
        conn.close()
    except exc.OperationalError:
        return_val = []
        curr_json = {}
        curr_json["ErrorCode"] = 69420
        curr_json["UserName"] = username
        return_val.append(json.dumps(curr_json))
        return json.dumps(return_val)
    return_val = []
    curr_json = {}
    curr_json["ErrorCode"] = 200
    curr_json["UserName"] = username
    return_val.append(json.dumps(curr_json))
    return json.dumps(return_val)

def popmovies():
    conn = db.connect()
    conn.execute("CALL mostPopular();")
    query = "SELECT * FROM moviePopTable ORDER BY movieCount DESC;"

    query_results = conn.execute(query).fetchall()

    print(query_results)

    return_list = []
    for result in query_results:
        
        curr_json = {}
        curr_json["movieName"] = result[0]
        curr_json["movieCount"] = str(result[1])
        curr_json["moviePop"] = result[2]

        return_list.append(json.dumps(curr_json))
    conn.close()

    return json.dumps(return_list)

def poptv():
    conn = db.connect()
    conn.execute("CALL mostPopular();")
    query = "SELECT * FROM tvPopTable ORDER BY tvCount DESC;"
    query_results = conn.execute(query).fetchall()
    return_list = []
    for result in query_results:
        curr_json = {}
        curr_json["tvName"] = result[0]
        curr_json["tvCount"] = str(result[1])
        curr_json["tvPop"] = result[2]
        return_list.append(json.dumps(curr_json))

    conn.close()
    return json.dumps(return_list) 

def filtergenrehelp(username : str, genre : str) -> None:
    conn = db.connect()
    idquery = 'SELECT UserId FROM UserProfile WHERE UserName = "{}"'.format(username)
    idset = conn.execute(idquery).fetchall()
    userId = idset[0][0]
    isAdult = userId[0]
    topmoviequery = """(SELECT titleId 
                        FROM Movies 
                        WHERE genres LIKE \'%%{}%%\' AND isAdult = {} 
                        ORDER BY averageRating DESC 
                        LIMIT 4)
                        UNION
                        (SELECT titleId 
                        FROM TV 
                        WHERE genres LIKE \'%%{}%%\'
                        ORDER BY averageRating DESC 
                        LIMIT 4);
                        ;""".format(genre, isAdult, genre)
    resultset = conn.execute(topmoviequery).fetchall()
    for result in resultset:
        toAdd = result[0]
        insertquery = 'INSERT INTO RecommendedList(UserId, EntertainmentId) VALUES("{}", "{}");'.format(userId, toAdd)
        conn.execute(insertquery)
    conn.close()

def filteractorhelp(username : str, actorname : str) -> None:
    conn = db.connect()
    idquery = 'SELECT UserId FROM UserProfile WHERE UserName = "{}"'.format(username)
    idset = conn.execute(idquery).fetchall()
    userId = idset[0][0]
    isAdult = userId[0]
    topmoviequery = """(SELECT m.titleId 
                        FROM Actors a NATURAL JOIN Acts aa NATURAL JOIN Movies m 
                        WHERE a.actorName = "{}" 
                        ORDER BY m.averageRating DESC 
                        LIMIT 5) 
                        UNION
                        (SELECT t.titleID
                        FROM Actors a NATURAL JOIN Acts aa NATURAL JOIN TV t
                        WHERE a.actorName= "{}"
                        ORDER BY t.averageRating DESC
                        LIMIT 5);""".format(actorname, actorname)
    resultset = conn.execute(topmoviequery).fetchall()
    for result in resultset:
        toAdd = result[0]
        insertquery = 'INSERT INTO RecommendedList(UserId, EntertainmentId) VALUES("{}", "{}");'.format(userId, toAdd)
        conn.execute(insertquery)
    conn.close()

