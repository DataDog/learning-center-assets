#!/usr/bin/python3

import os
import sys
import time
import requests
import json
import random

if 'SAA_IP' not in os.environ:
    print('$SAA_IP is not set')
    sys.exit(1)

host = 'http://{ip_address}'.format(ip_address=os.environ['SAA_IP'])
print(host)

# Run once unless an argument is given e.g. `postlogs.py 10`
posts = int(sys.argv[1]) if len(sys.argv) > 1 else 1

items = [
        {'product':'datadog-jr-spaghetti','source':'twitter','sentiment':0},
        {'product':'spree-jr-spaghetti','source':'facebook','sentiment':1},
        {'product':'datadog-jr-spaghetti','source':'tiktok','sentiment': -1},
        {'product':'datadog-mug','source':'instagram','sentiment':0},
        {'product':'datadog-stein','source':'twitter','sentiment':1},
        {'product':'monitoring-stein','source':'facebook','sentiment':-1},
        {'product':'monitoring-mug','source':'tiktok','sentiment':0},
        {'product':'datadog-tote','source':'instagram','sentiment':1},
        {'product':'datadog-bag','source':'twitter','sentiment':-1},
        {'product':'spree-tote','source':'facebook','sentiment':0},
        {'product':'spree-bag','source':'tiktok','sentiment':1}
]

def post_sentiment():
    post_url='{host}/create'.format(host=host)
    headers = {
      'Content-Type' : 'application/json',
    }
    r=requests.post(post_url, data=json.dumps(random.choice(items)), headers=headers)
    print(r)

def get_sentiment():
    get_url='{host}/query?minutes=20'.format(host=host)
    r=requests.get(get_url)
    print(r)

for i in range(posts):
    post_sentiment()
    get_sentiment()
    time.sleep(3)