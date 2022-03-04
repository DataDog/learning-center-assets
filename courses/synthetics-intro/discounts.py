import requests
import random
import time
import names
import json

from flask import Flask, Response, jsonify
from flask import request

from sqlalchemy.orm import joinedload

from bootstrap import create_app
from models import Discount, DiscountType, Influencer, db

app = create_app()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

@app.route('/')
def hello():
    return Response({'Hello from Discounts!': 'world'}, mimetype='application/json')

@app.route('/discount', methods=['GET'])
def get_discount():

    try:
        discounts = Discount.query.options(joinedload('*')).all()
        app.logger.info(f"Discounts available: {len(discounts)}")

        influencer_count = 0
        for discount in discounts:
            if discount.discount_type.influencer:
                influencer_count += 1
        app.logger.info(f"Total of {influencer_count} influencer specific discounts as of this request")
        return jsonify([b.serialize() for b in discounts])

    except:

        app.logger.error("An error occurred while getting discounts.")
        err = jsonify({'error': 'Internal Server Error'})
        err.status_code = 500
        return err

@app.route('/discount', methods=['POST'])
def add_discount():

    try:
        # Create a new discount with random name and value. 
        with open('words.json') as f:
            words = json.load(f)

        discount_type = DiscountType(random.choice(words),
                                     'price * %f' % random.random(),
                                     Influencer(names.get_full_name()))

        discount_name = random.choice(words)

        for i in range(random.randint(1,3)):
            discount_name += ' ' + random.choice(words)

        new_discount = Discount(discount_name, 
                                random.choice(words).upper(),
                                random.randrange(1,100) * random.random(),
                                discount_type)
        app.logger.info(f"Adding discount with name {discount_name}")
        db.session.add(new_discount)
        db.session.commit()
        new_id = new_discount.id
        app.logger.info(f"New discount {new_discount.name} added with id {new_discount.id}")

        return jsonify({"id": new_id})

    except:

        app.logger.error("An error occurred while creating a new discount.")
        err = jsonify({'error': 'Internal Server Error'})
        err.status_code = 500
        return err

@app.route('/discount/<id>', methods=['DELETE'])
def delete_discount(id):
    # delete a record with the given id

    app.logger.info("Deleting discount with id %d", id)
    Discount.query.filter(Discount.id == id).delete()
    db.session.commit()
    app.logger.info("Discount id %d deleted", id)

    return jsonify({"id": id})
