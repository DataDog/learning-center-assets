#!/bin/bash

# Declare some variables ahead of time
ALL_MONITORS=""
MONITOR=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
JSON_DIR="/root/monitors" # location of json files
API_URL="https://api.datadoghq.com/api/v1/monitor" # alert

# Get a list of all monitors
ALL_MONITORS=$(
    ${CMD_CURL} -X GET "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} '.[].name'
)

# Read files in JSON_DIR and use jq to get monitor name.
# Check if the monitor already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for file in ${JSON_DIR}/*.json
do
  MONITOR=$( ${CMD_JQ} '.name' ${file} )
  if [[ ${ALL_MONITORS} =~ ${MONITOR} ]]
  then
    echo "Monitor exists: ${MONITOR}"
  else
    ${CMD_CURL} -X POST "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${file}

    echo "Monitor created: ${MONITOR}"
  fi
done