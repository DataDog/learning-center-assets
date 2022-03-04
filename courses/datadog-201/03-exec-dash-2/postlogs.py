#!/usr/bin/python3

import os
import sys
import time
import requests
import json
import random

# Run once unless an argument is given e.g. `postlogs.py 10`
posts = int(sys.argv[1]) if len(sys.argv) > 1 else 1

items = [
	{'id':'datadog-jr-spaghetti','name':'Datadog Jr. Spaghetti','price:':19.99,'cost':5.10},
	{'id':'spree-jr-spaghetti','name':'Spree Jr. Spaghetti','price':19.99,'cost':5.10},
	{'id':'datadog-jr-spaghetti','name':'Datadog Jr. Spaghetti','price':19.99,'cost':5.10},
	{'id':'datadog-mug','name':'Datadog Mug','price':13.99,'cost':2.15},
	{'id':'datadog-stein','name':'Datadog Stein','price':16.99,'cost':4.00},
	{'id':'monitoring-stein','name':'Monitoring Stein','price':16.99,'cost':3.50},
	{'id':'monitoring-mug','name':'Monitoring Mug','price':13.99,'cost':3.50},
	{'id':'datadog-tote','name':'Datadog Tote','price':15.99,'cost':5.00},
	{'id':'datadog-bag','name':'Datadog Bag','price':22.99,'cost':5.70},
	{'id':'spree-tote','name':'Spree Tote','price':15.99,'cost':3.60},
	{'id':'spree-bag','name':'Spree Bag','price':22.99,'cost':6.30},
]

def post_log():
    headers = {
      'Content-Type' : 'application/json',
      'DD-API-KEY': os.environ['DD_API_KEY']
    }
    url = 'https://http-intake.logs.datadoghq.com/v1/input'
    payload = {
      'ddsource': 'python',
      'ddtags': 'env:dd201, team:frontend',
      'hostname': 'host01',
      'message': '{"event":"add_to_cart","item":' + json.dumps(random.choice(items)) + '}',
      'service': 'store-cartlogger'
    }
    r=requests.post(url, data=json.dumps(payload), headers=headers)

for i in range(posts):
    post_log()
    time.sleep(3)
