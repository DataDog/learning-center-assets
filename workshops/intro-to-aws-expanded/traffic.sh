#!/usr/bin/bash

# Ensure env vars are set
if [ -z "$STOREDOG_URL" ]
then
  echo "\$STOREDOG_URL is not set."
  exit 1
fi

if [ -z "$SAA_IP" ] 
then
  echo "\$SAA_IP is not set."
  exit 1
fi

# Run the storedog traffic gen, if it isn't already running
if [ ! "$(docker ps -q -f name="storedog-traffic")" ]; then
    if [ "$(docker ps -aq -f status=exited -f name="storedog-traffic")" ]; then
        # cleanup
        docker rm "storedog-traffic"
    fi
    docker run --rm -d \
      --name storedog-traffic \
      -e STOREDOG_URL=$STOREDOG_URL \
      -v /root/puppeteer-mobile.js:/puppeteer.js \
      -v /root/puppeteer.sh:/puppeteer.sh \
      buildkite/puppeteer:10.0.0 \
      bash puppeteer.sh
fi

# Run the sentiment analysis API traffic gen, if it isn't already running
if [ ! "$(docker ps -q -f name="saa-traffic")" ]; then
    if [ "$(docker ps -aq -f status=exited -f name="saa-traffic")" ]; then
        # cleanup
        docker rm "saa-traffic"
    fi
    docker run --rm -d \
      --name saa-traffic \
      -e SAA_IP=$SAA_IP \
      -v /root/sentiment_driver.py:/app.py \
      python:3.8-alpine sh -c "pip install requests && python3 /app.py 1024"
fi