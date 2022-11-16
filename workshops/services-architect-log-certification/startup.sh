#!/bin/bash
set -x

# start 2 services, one producing business logs, the other senstive business logs
/root/business-app -i 1 >> /root/lab/business-app.log &
/root/sensitive-app -f sensitive -i 1 >> /root/labsensitive-app.log &