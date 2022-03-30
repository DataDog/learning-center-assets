#!/usr/bin/bash

wait-for-it --timeout=60 localhost:80

STATELY_URL=$(cat /root/stately_url.txt)
while true
do
  curl -s $STATELY_URL > /dev/null
  sleep 1
  curl -s -X POST $STATELY_URL/state \
    -H "Content-Type: application/json" \
    -H "X-Requested-With: cURL" > /dev/null
  sleep 2
done