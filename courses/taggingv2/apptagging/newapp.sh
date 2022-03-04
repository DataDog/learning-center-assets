#!/bin/bash

docker-compose -f docker-compose-broken.yml stop
docker-compose -f docker-compose-broken.yml rm -f
docker-compose -f docker-compose-fixed.yml up -d
clear
