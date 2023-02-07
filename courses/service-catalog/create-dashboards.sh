#!/bin/bash

# Declare some variables ahead of time
ALL_DASHBOARDS=""
DASHBOARD=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
JSON_DIR="/root/dashboards" # location of json files
API_URL="https://api.datadoghq.com/api/v1/dashboard" # dashboard

# Get a list of all dashboards
ALL_DASHBOARDS=$(
    ${CMD_CURL} -X GET "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} '.dashboards[].title'
)

# Read files in JSON_DIR and use jq to get dashboard name.
# Check if the dashboard already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for file in ${JSON_DIR}/*.json
do
  DASHBOARD=$( ${CMD_JQ} '.title' ${file} )
  if [[ ${ALL_DASHBOARDS} =~ ${DASHBOARD} ]]
  then
    echo "Dashboard exists: ${DASHBOARD}"
  else
    ${CMD_CURL} -X POST "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${file}

    echo "Dashboard created: ${DASHBOARD}"
  fi
done
