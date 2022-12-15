#!/bin/bash
  
while true; do
  case "$1" in
    --start )
        if pgrep java
        then
          echo "petclinic is already running"
        else
          nohup java -Dserver.port=8090 -jar spring-petclinic/target/spring-petclinic-*.jar &
        fi
        break ;;
    --stop ) pkill java
        break ;;
    --restart ) pkill java
        nohup java -Dserver.port=8090 -jar spring-petclinic/target/spring-petclinic-*.jar &
        break ;;
    * ) echo "script usage: $(basename $0) [--start|stop|restart]"
        break ;;
  esac
done