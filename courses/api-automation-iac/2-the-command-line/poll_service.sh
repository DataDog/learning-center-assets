#!/usr/bin/bash

echo "Waiting for $DD_SERVICE..."
SERVICE_UP=false
while [ $SERVICE_UP == false ]
do
  TO=$(date +"%s")
  FROM=$(expr $TO - 60)
  sleep 2
  SERVICE_UP=$(curl -s -X GET "https://api.datadoghq.com/api/v1/query?from=$FROM&to=$TO&query=avg:$DD_QUERY_METRIC\{env:$DD_ENV,service:$DD_SERVICE,host:$DD_HOSTNAME\}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" |jq '.series|length>0')
done
echo "$DD_SERVICE is up. Sending event."

EVENT_RESPONSE=$(curl -s -X POST "https://api.datadoghq.com/api/v1/events" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-d @- << EOF
{
  "title": "$DD_SERVICE is up",
  "text": "The service polling script detected $DD_QUERY_METRIC from $DD_SERVICE in $DD_ENV.",
  "tags" : [
    "env:$DD_ENV",
    "service:$DD_SERVICE",
    "host:$DD_HOSTNAME"
  ]
}
EOF
) 

if [ $(echo $EVENT_RESPONSE | jq '.status == "ok"') == true ]
then
  echo "Event sent OK"
else
  echo "Event not sent"
fi
