import requests

from flask import Flask, Response, jsonify, render_template
from flask import request as flask_request

from flask_cors import CORS
import os

from ddtrace import tracer
from ddtrace.ext.priority import USER_REJECT, USER_KEEP

import subprocess
import random

from os import environ

app = Flask('api')

if os.environ['FLASK_DEBUG']:
    CORS(app)

SENSORS_URL = f"http://{environ['SENSORS_API_SERVICE_HOST']}:{environ['SENSORS_API_SERVICE_PORT_HTTP']}"
PUMPS_URL = f"http://{environ['PUMPS_SERVICE_SERVICE_HOST']}:{environ['PUMPS_SERVICE_SERVICE_PORT']}"
NODE_URL = f"http://{environ['NODE_API_SERVICE_HOST']}:{environ['NODE_API_SERVICE_PORT_HTTP']}"

app.logger.info("Sensors URL: " + SENSORS_URL)
app.logger.info("Pumps URL: " + PUMPS_URL)
app.logger.info("Node URL: " + NODE_URL)

@app.route('/')
def homepage():
    return app.send_static_file('index.html')

@app.route('/service-worker.js')
def service_worker_js():
    return app.send_static_file('js/service-worker.js')

@app.route('/status')
def system_status():
    status = requests.get(f"{SENSORS_URL}/sensors").json()
    app.logger.info(f"Sensor status: {status}")
    pumps = requests.get(f"{PUMPS_URL}/devices").json()
    users = requests.get(f"{NODE_URL}/users").json()
    return jsonify({'sensor_status': status, 'pump_status': pumps, 'users': users})

@app.route('/users', methods=['GET', 'POST'])
def users():
    if flask_request.method == 'POST':
        newUser = flask_request.get_json()
        userStatus = requests.post(f"{NODE_URL}/users", json=newUser).json()
        return jsonify(userStatus)
    elif flask_request.method == 'GET':
        users = requests.get(f"{NODE_URL}/users").json()
        return jsonify(users)

@app.route('/add_sensor')
def add_sensor():
    sensors = requests.post(f"{SENSORS_URL}/sensors").json()
    return jsonify(sensors)
    
@app.route('/add_pump', methods=['POST'])
def add_pump():
    pumps = requests.post(f"{PUMPS_URL}/devices").json()
    app.logger.info(f"Getting {pumps}")
    return jsonify(pumps)

@app.route('/generate_requests', methods=['POST'])
def call_generate_requests():
    payload = flask_request.get_json()
    span = tracer.current_span()
    app.logger.info(f"Looking at {span}")
    app.logger.info(f"with span id {span.span_id}")

    span = tracer.current_span()
    
    span.set_tags({'requests': payload['total'], 'concurrent': payload['concurrent']})

    output = subprocess.check_output(['ddtrace-run', 
                                      '/app/traffic_generator.py',
                                      str(payload['concurrent']), 
                                      str(payload['total']),
                                      str(payload['url'])])
    app.logger.info(f"Result for subprocess call: {output}")
    return jsonify({'traffic': str(payload['concurrent']) + ' concurrent requests generated, ' + 
                               str(payload['total'])  + ' requests total.',
                    'url': payload['url']})

# generate requests for one user to see tagged
# enable user sampling because low request count
@app.route('/generate_requests_user')
def call_generate_requests_user():
    users = requests.get(f"{NODE_URL}/users").json()
    user = random.choice(users)
    span = tracer.current_span()
    span.context.sampling_priority = USER_KEEP
    span.set_tags({'user_id': user['id']})

    output = subprocess.check_output(['ddtrace-run',
                                    '/app/traffic_generator.py',
                                    '20',
                                    '100',
                                    f"{NODE_URL}/users/" + user['uid']])
    app.logger.info(f"Chose random user {user['name']} for requests: {output}")
    return jsonify({'random_user': user['name']})

@app.route('/simulate_sensors')
def simulate_sensors():
    sensors = requests.get(f"{SENSORS_URL}/refresh_sensors").json()
    return jsonify(sensors)