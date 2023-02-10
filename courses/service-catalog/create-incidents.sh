#!/bin/bash

# Declare some variables ahead of time
ALL_INCIDENTS=""
INCIDENT=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
JSON_DIR="/root/incidents" # location of json files
API_URL="https://api.datadoghq.com/api/v2/incidents" # incident

# Get a list of all incidents
ALL_INCIDENTS=$(
    ${CMD_CURL} -X GET "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} '.data[].attributes.title'
)

# Read files in JSON_DIR and use jq to get incident name.
# Check if the incident already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for file in ${JSON_DIR}/*.json
do
  INCIDENT=$( ${CMD_JQ} '.data.attributes.title' ${file} )
  if [[ ${ALL_INCIDENTS} =~ ${INCIDENT} ]]
  then
    echo "Incident exists: ${INCIDENT}"
  else
    ${CMD_CURL} -X POST "${API_URL}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${file}

    echo "Incident created: ${INCIDENT}"
  fi
done
