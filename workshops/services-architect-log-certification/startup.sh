#!/bin/bash

while true; do
  case "$1" in
    --start )
        if ps aux | grep -q "[b]usiness-app"
        then
          echo "business-app is already running"
        else
          /root/business-app -i 1 >> /root/lab/business-app.log &
        fi
        if ps aux | grep -q "[s]ensitive-app"
        then
          echo "sensitive-app is already running"
        else
          /root/sensitive-app -f sensitive -i 1 >> /root/labsensitive-app.log &
        fi
        break ;;
    --stop ) pkill business-app 
        pkill sensitive-app
        break ;;
    --restart ) pkill business-app 
        pkill sensitive-app
        /root/business-app -i 1 >> /root/lab/business-app.log and &
        /root/sensitive-app -f sensitive -i 1 >> /root/labsensitive-app.log &
        break ;;
    * ) echo "script usage: $(basename $0) [--start|stop|restart]"
        break ;;
  esac
done