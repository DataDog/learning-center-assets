#!/bin/bash

while true; do
  case "$1" in
    --start )
        if ps aux | grep -q "[b]usiness-app"
        then
          echo "business-app is already running"
        else
          /usr/local/business/bin/business-app -i 1 >> /usr/local/business/logs/business.log &
        fi
        if ps aux | grep -q "[s]ensitive-app"
        then
          echo "sensitive-app is already running"
        else
          /usr/local/sensitive/bin/sensitive-app -f sensitive -i 1 >> /usr/local/sensitive/logs/sensitive.log &
        fi
        break ;;
    --stop ) pkill business-app 
        pkill sensitive-app
        break ;;
    --restart ) pkill business-app 
        pkill sensitive-app
        /usr/local/business/bin/business-app -i 1 >> /usr/local/business/logs/business-app.log and &
        /usr/local/sensitive/bin/sensitive-app -f sensitive -i 1 >> /usr/local/sensitive/logs/sensitive.log &
        break ;;
    * ) echo "script usage: $(basename $0) [--start|stop|restart]"
        break ;;
  esac
done