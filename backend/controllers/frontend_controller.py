from flask import jsonify, request
import re
from datetime import date
from db import DB


def get_details():
    id = request.args.get("id")
    msg = ''
    if len(id) != 0:
        results = DB().executeQuery('SELECT * FROM pets WHERE id = % s', (int(id), ))
        # results = cursor.fetchone()
        if results:
            return jsonify(results)
        else:
            msg = "The cat doesn't exist in database."
    else:
        msg = "Pet's id could not be null."
    return jsonify({'message': msg})


def add_a_cat():
    msg = ''
    req_data = request.get_json()
    if req_data and "name" in req_data and "age" in req_data and "sex" in req_data:
        name = req_data["name"]
        age = req_data["age"]
        sex = req_data["sex"]
        if (len(name) > 0) & (len(age) > 0) & (len(sex) > 0):
            if not re.match(r'[A-Za-z0-9]+', name):
                msg = 'name must contain only characters and numbers !'
            else:
                DB().execute(
                    'INSERT INTO pets VALUES (NULL, % s, % s, % s)', (name, age, sex,))
                # db.commit()
                msg = 'The details of the cat is added into database ！'
    else:
        msg = 'Name, Age, Sex could not be null !'
    return jsonify({
        "error": False,
        'message': msg,
    })


def update_details(id):
    msg = ''
    if request.method == 'PUT':
        results = DB().executeQuery('SELECT * FROM pets WHERE id = % s', (id, ))
        # results = cursor.fetchone()
        if results:
            name = request.form['name']
            age = request.form['age']
            sex = request.form['sex']
            try:
                DB().execute(
                    'UPDATE pets SET NAME =% s, age =% s, sex =% s WHERE id =% s', (name, age, sex, (id, ), ))
                # db.commit()
                msg = 'The details of the cat is updated ！'
            except:
                return 'There was a problem updating...'
        else:
            msg = "The cat doesn't exist in database."
    return msg


def delete_a_cat(id):
    msg = ''
    if request.method == 'DELETE':
        results = DB().execute('SELECT * FROM pets WHERE id = % s', (id, ))
        # results = cursor.fetchone()
        if results:
            try:
                DB().execute('DELETE FROM pets WHERE id =% s', (id, ))
                # db.commit()
                msg = 'The details of the cat is deleted ！'
            except:
                return 'There was a problem deleting...'
        else:
            msg = "The cat doesn't exist in database."
    return msg


def get_weight():
    id = request.args.get("id")
    if len(id) != 0:
        results = DB().executeQuery(
            'SELECT * FROM weight WHERE id = % s ORDER BY weight_date', (int(id), ))
        # results = cursor.fetchall()
        if results:
            # format date as "yyyy-MM-dd"
            for row in results:
                row['weight_date'] = row['weight_date'].strftime('%Y-%m-%d')
            # return results as JSON response
            return jsonify({
                "error": False,
                "message": "Success",
                "data": results
            })
        else:
            return jsonify({
                "error": True,
                "message": "No data for the cat.",
                "data": []
            })
    else:
        return jsonify({
            "error": True,
            "message": "Pet's id could not be null.",
            "data": []
        })


def add_weight():
    msg = ''
    if request.method == 'POST':
        req_data = request.get_json()
        if req_data and "id" in req_data and "weight" in req_data:
            id = req_data["id"]
            weight = req_data["weight"]
            today = date.today()
            if id is not None and id > 0 and weight is not None and weight > 0:
                DB().execute(
                    'REPLACE INTO weight VALUES (NULL, %s, %s, %s)',
                    (id, weight, today,)
                )
                # db.commit()
                msg = 'The weight of the cat is added into database!'
            else:
                msg = 'Invalid request data! Please provide valid id, weight and date.'
            feedingDuration = 0
        else:
            msg = 'Invalid request data! Please provide id, weight and date.'
            feedingDuration = 0
    return jsonify({
        'feedingDuration': feedingDuration,
        'message': msg
    })


def def_meal_time():
    msg = ''
    if request.method == 'POST':
        req_data = request.get_json()
        if req_data and "owner_name" in req_data and "per_name" in req_data\
                and "start_time" in req_data and "end_time" in req_data:
            pass


def get_feeding_records():
    id = request.args.get("id")
    if len(id) != 0:
        results = DB().executeQuery(
            'SELECT * FROM feeding_records WHERE id = % s ORDER BY feed_date DESC', (int(id), ))
        # results = cursor.fetchall()
        if results:
            # format date as "yyyy-MM-dd"
            for row in results:
                row['feed_date'] = row['feed_date'].strftime(
                    '%Y-%m-%d %H:%M:%S')
            # return results as JSON response
            return jsonify({
                "error": False,
                "message": "Success",
                "data": results
            })
        else:
            return jsonify({
                "error": True,
                "message": "No data for the cat.",
                "data": []
            })
    else:
        return jsonify({
            "error": True,
            "message": "Pet's id could not be null.",
            "data": []
        })
