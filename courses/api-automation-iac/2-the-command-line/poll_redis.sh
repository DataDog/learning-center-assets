#!/usr/bin/bash
REDIS_UP=false
while [ $REDIS_UP == false ]
do
  TO=$(date +"%s")
  FROM=$(expr $TO - 60)
  sleep 2
  echo 'Waiting for redis-session-cache...'
  REDIS_UP=$(curl -s -X GET "https://api.datadoghq.com/api/v1/query?from=$FROM&to=$TO&query=avg:redis.cpu.sys\{env:api-course,service:redis-session-cache,host:$DD_HOSTNAME\}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" |jq '.series|length>0')
done
echo 'redis-session-cache is up.'
