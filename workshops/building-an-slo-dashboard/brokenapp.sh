#!/bin/bash

clear
docker-compose -f docker-compose-fixed-instrumented.yml stop
docker-compose -f docker-compose-fixed-instrumented.yml rm -f
docker-compose -f docker-compose-broken-instrumented.yml up -d
clear
envready