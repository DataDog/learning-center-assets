from flask_sqlalchemy import SQLAlchemy
import datetime

db = SQLAlchemy()

class Pump(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128))
    pump_status = db.Column(db.String(64))
    pump_capacity = db.Column(db.Float())

    def __init__(self, name, status, capacity):
        self.name = name
        self.pump_status = status
        self.pump_capacity = capacity
    
    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'status': self.pump_status,
            'gph': self.pump_capacity
        }


    