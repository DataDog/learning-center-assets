import requests
import random
import time
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import words

from flask import Flask, Response, jsonify
from flask import request as flask_request
from flask_cors import CORS

from sqlalchemy.orm import joinedload

from bootstrap import create_app
from models import Discount, DiscountType, db

app = create_app()
CORS(app)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

@app.route('/')
def hello():
    return Response({'Hello from Discounts!': 'world'}, mimetype='application/json')

@app.route('/discount', methods=['GET', 'POST'])
def status():
    if flask_request.method == 'GET':
        discounts = Discount.query.options(joinedload('*')).all()
        app.logger.info(f"Discounts available: {len(discounts)}")

        influencer_count = 0
        for discount in discounts:
            if discount.discount_type.influencer:
                influencer_count += 1
        app.logger.info(f"Total of {influencer_count} influencer specific discounts as of this request")
        # time experiment. DO NOT RELEASE TO PRODUCTION!!!!
        time.sleep(2.5)
        return jsonify([b.serialize() for b in discounts])

    elif flask_request.method == 'POST':
        # create a new discount with random name and value
        discounts_count = len(Discount.query.all())
        new_discount_type = DiscountType('Random Savings',
                                         'price * .9',
                                         None)
        new_discount = Discount('Discount ' + str(discounts_count + 1),
                                words.get_random(random.randomint(2,4)),
                                random.randint(10,500),
                                new_discount_type)
        app.logger.info(f"Adding discount {new_discount}")
        db.session.add(new_discount)
        db.session.commit()
        discounts = Discount.query.all()

        return jsonify([b.serialize() for b in discounts])
    else:
        err = jsonify({'error': 'Invalid request method'})
        err.status_code = 405
        return err

@app.route('/discount-code', methods=['GET'])
def getDiscount():
    if flask_request.method == 'GET':
        # get the discount code from the query string
        discount_code = flask_request.args.get('discount_code')
        # log the discount code
        app.logger.info(f"Discount code: {discount_code}")
        discount = Discount.query.filter_by(code=discount_code).first()
        time.sleep(2.5)
        # randomly error out
        if random.randint(1, 100) <= 15:
            err = jsonify({'error': 'Internal Server Error'})
            err.status_code = 500
            return err
        else:
          if discount:
            return jsonify(discount.serialize())
          else:
            err = jsonify({'error': 'Discount not found'})
            err.status_code = 404
            return err
    else:
        err = jsonify({'error': 'Invalid request method'})
        err.status_code = 405
        return err