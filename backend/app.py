# Store this code in 'app.py' file
# import MySQLdb
# from flask_mysqldb import MySQL
from flask import Flask, request, jsonify
from flask_mqtt import Mqtt
from flask_swagger_ui import get_swaggerui_blueprint
from controllers import frontend_controller, mqtt_controller
import json
from datetime import datetime
from db import DB


app = Flask(__name__)


SWAGGER_URL = '/swagger'  # URL for exposing Swagger UI (without trailing '/')
API_URL = '/static/swagger.json'  # API url

# Call factory function to create our blueprint
swaggerui_blueprint = get_swaggerui_blueprint(
    # Swagger UI static files will be mapped to '{SWAGGER_URL}/dist/'
    SWAGGER_URL,
    API_URL,
    config={  # Swagger UI config overrides
        'app_name': "Hello-Kitty"
    },
    # oauth_config={  # OAuth config. See https://github.com/swagger-api/swagger-ui#oauth2-configuration .
    #    'clientId': "your-client-id",
    #    'clientSecret': "your-client-secret-if-required",
    #    'realm': "your-realms",
    #    'appName': "your-app-name",
    #    'scopeSeparator': " ",
    #    'additionalQueryStringParams': {'test': "hello"}
    # }
)

app.register_blueprint(swaggerui_blueprint)

app.secret_key = 'your secret key'
# app.config['MYSQL_HOST'] = 'ec2-34-246-195-200.eu-west-1.compute.amazonaws.com'
# app.config['MYSQL_USER'] = 'root'
# app.config['MYSQL_PASSWORD'] = 'p@ssword'
# app.config['MYSQL_DB'] = 'kitty'
app.config['MQTT_BROKER_URL'] = 'a3s8fm7ruabocj-ats.iot.eu-west-1.amazonaws.com'
app.config['MQTT_BROKER_PORT'] = 8883
app.config['MQTT_TLS_ENABLED'] = True
app.config['MQTT_TLS_INSECURE'] = True
app.config['MQTT_TLS_VERSION'] = 2
app.config['MQTT_TLS_CA_CERTS'] = 'certs/AmazonRootCA1.pem'
app.config['MQTT_TLS_CERTFILE'] = 'certs/certificate.pem.crt'
app.config['MQTT_TLS_KEYFILE'] = 'certs/private.pem.key'


# mysql = MySQL(app)
mqtt_client = Mqtt(app)


@app.route('/getDetails', methods=['GET'])
def get_details():
    return frontend_controller.get_details()


@app.route('/addACat', methods=['POST'])
def add_a_cat():
    return frontend_controller.add_a_cat()


@app.route('/updateDetails/<int:id>', methods=['PUT'])
def update_details(id):
    return frontend_controller.update_details(id)


@app.route('/deleteACat/<int:id>', methods=['DELETE'])
def delete_a_cat(id):
    return frontend_controller.delete_a_cat(id)


@app.route('/getWeight', methods=['GET'])
def get_weight():
    return frontend_controller.get_weight()


@app.route('/addWeight', methods=['POST'])
def add_weight():
    return frontend_controller.add_weight()


@app.route('/defMealTime', methods=['POST'])
def def_meal_time():
    return frontend_controller.def_meal_time()


@app.route('/getFeedingRecords', methods=['GET'])
def get_feeding_records():
    return frontend_controller.get_feeding_records()


###############
# MQTT handling
###############


def add_weight(client, userdata, message):
    return mqtt_controller.add_weight(client, userdata, message)


def less_food(client, userdata, message):
    return mqtt_controller.add_weight(client, userdata, message)


# Define functions to handle each topic
def flask_test(client, userdata, message):
    data = dict(
        topic=message.topic,
        payload=message.payload.decode()
    )
    print(
        'Received message on topic: {topic} with payload: {payload}'.format(**data))


topic_handlers = {
    'esp32/humidity_temperature_weight': add_weight,
    '/flask/mqtt': flask_test
}


@mqtt_client.on_connect()
def handle_connect(client, userdata, flags, rc):
    if rc == 0:
        print('Connected successfully')
        for topic in topic_handlers.keys():
            mqtt_client.subscribe(topic)  # subscribe topic
            print(f'Subscribed topic {topic}')
    else:
        print('Bad connection. Code:', rc)


@mqtt_client.on_message()
def handle_mqtt_message(client, userdata, message):
    topic = message.topic
    if topic in topic_handlers:
        topic_handlers[topic](client, userdata, message)
    else:
        print(f'No handler found for topic {topic}')


@app.route('/publish', methods=['POST'])
def publish_message():
    request_data = request.get_json()
    publish_result = mqtt_client.publish(
        request_data['topic'], json.dumps({'message': f"{request_data['msg']}"}))
    # mannual feeding
    id = request_data['id']
    currentDateAndTime = datetime.now()
    # cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    DB().execute(
        'insert into feeding_records values(NULL, %s, %s, %s, %s)',
        (id, "Manual", 5, currentDateAndTime,)
    )
    # mysql.connection.commit()
    print("Mannual feeding completed!")
    return jsonify({'code': publish_result[0]})


@app.route('/publish/mock', methods=['POST'])
def publish_message_mock():
    request_data = request.get_json()
    publish_result = mqtt_client.publish(
        request_data['topic'], json.dumps(request_data['message']))
    return jsonify({'code': publish_result[0]})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("8000"))
