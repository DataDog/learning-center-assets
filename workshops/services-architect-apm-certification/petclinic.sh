#!/bin/bash
  
while true; do
  case "$1" in
    --start )
        if pgrep java
        then
          echo "petclinic is already running"
        else
          nohup java -Dserver.port=8090 -Dlogging.level.org.springframework=DEBUG -jar spring-petclinic/target/*.jar> /root/lab/logs/petclinic.log 2>&1 &
        fi
        break ;;
    --stop ) pkill java
        break ;;
    --restart ) pkill java
        nohup java -Dserver.port=8090 -Dlogging.level.org.springframework=DEBUG -jar spring-petclinic/target/*.jar> /root/lab/logs/petclinic.log 2>&1 &
        break ;;
    * ) echo "script usage: $(basename $0) [--start|stop|restart]"
        break ;;
  esac
done