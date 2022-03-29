import random
import requests
# from  openzwave.network import ZWaveNetwork
# from openzwave.option import ZWaveOption

from flask import Flask, Response, jsonify
from flask import request as flask_request

from bootstrap import create_app
from models import Pump, db

app = create_app()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

@app.route('/')
def hello():
    return Response({'Hello from Oxygenation Pumps': 'world'}, mimetype='application/json')

@app.route('/devices', methods=['GET', 'POST'])
def status():
    if flask_request.method == 'GET':
        pumps = Pump.query.all()
        app.logger.info(f"Pumps available: {pumps}")
        pump_obj = {'pump_count': len(pumps),
                    'status': []}
        for pump in pumps:
            pump_obj['status'].append(pump.serialize())
        return jsonify(pump_obj)
    elif flask_request.method == 'POST':
        # create a new device w/ random status
        pumps_count = len(Pump.query.all())
        new_pump = Pump('Pump ' + str(pumps_count + 1), 
                        random.choice(['OFF', 'ON']),
                        random.randint(10,500))
        app.logger.info(f"Adding pump {new_pump}")
        db.session.add(new_pump)
        db.session.commit()
        pumps = Pump.query.all()
        
        return jsonify([b.serialize() for b in pumps])
    else:
        err = jsonify({'error': 'Invalid request method'})
        err.status_code = 405
        return err