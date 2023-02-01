#!/bin/bash

# Declare some variables ahead of time
declare -A MONITOR_ARRAY
ALL_MONITORS=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
JSON_DIR="/root/monitors/" # location of json files
API_URL="https://api.datadoghq.com/api/v1/monitor" # alert
# API_URL="https://api.datadoghq.com/api/v1/slo" # slo

# Read files in JSON_DIR and use jq to get monitor name.
# Then add filename and monitor name to MONITOR_ARRAY.
for file in ${JSON_DIR}/*.json
do
  MONITOR_ARRAY+=(
    [${file}]=$( ${CMD_JQ} '.name' ${file} )
  )
done

# Get a list of all monitors
ALL_MONITORS=$(
    ${CMD_CURL} -X GET "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
)

# Check if the monitor already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for key in ${!MONITOR_ARRAY[@]}
do
  if [[ ${ALL_MONITORS} =~ "${MONITOR_ARRAY[${key}]}" ]]
  then
    echo "Monitor exists: ${MONITOR_ARRAY[${key}]}"
  else
    ${CMD_CURL} -X POST "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${key}

    echo "Monitor created: ${MONITOR_ARRAY[${key}]}"
  fi
done
