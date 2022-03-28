from flask import Flask
from models import Pump, db

import os
DB_USERNAME = os.environ['POSTGRES_USER']
DB_PASSWORD = os.environ['POSTGRES_PASSWORD']
DB_HOST = os.environ['POSTGRES_SERVICE_HOST']

def create_app():
    """Create a Flask application"""
    app = Flask(__name__)
    #app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://' + DB_USERNAME + ':' + DB_PASSWORD + '@' + DB_HOST + '/' + DB_USERNAME
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)
    initialize_database(app, db)
    return app


def initialize_database(app, db):
    """Drop and restore database in a consistent state"""
    with app.app_context():
        db.drop_all()
        db.create_all()
        first_pump = Pump('Pump 1', 'OFF', 5.1)
        second_pump = Pump('Pump 2', 'OFF', 3002.1)
        third_pump = Pump('Pump 3', 'ON', 5242.1)
        db.session.add(first_pump)
        db.session.add(second_pump)
        db.session.add(third_pump)
        db.session.commit()