#!/bin/bash

# Declare some variables ahead of time
ALL_SLOS=""
SLO=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
JSON_DIR="/root/slos" # location of json files
API_URL="https://api.datadoghq.com/api/v1/slo" # slo
MONITOR_SEARCH_URL="https://api.datadoghq.com/api/v1/monitor/search"

# Check for monitor based slo
for file in ${JSON_DIR}/*.json
do
  if $(${CMD_JQ} 'has("monitor_ids")' ${file})
  then
    echo "Monitor based SLO: ${file##*/}"
    # get name of SLO
    SLO_NAME=$( ${CMD_JQ} --raw-output '.name' ${file} )

    # search monitors for name and get monitor id
    MONITOR_ID=$( 
      ${CMD_CURL} -X GET --data-urlencode "query=${SLO_NAME}" \
      "${MONITOR_SEARCH_URL}" \
      -H "Accept: application/json" \
      -H "DD-API-KEY: ${DD_API_KEY}" \
      -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
      | ${CMD_JQ} --raw-output '.monitors[].id'
    )
    if [[ ${MONITOR_ID} ]]
    then
      # A temp file is needed to hold results before overwrting the file
      TEMP_FILE=$(mktemp)

      ${CMD_JQ} --argjson newid ${MONITOR_ID} \
      '(.monitor_ids[]) |= $newid' ${file} > ${TEMP_FILE} && \
      mv -- "${TEMP_FILE}" ${file}
      echo "Monitor id has been updated"
    else
      echo "No matching Monitor was found for SLO: ${file##*/}"
    fi
  else
    echo "Metric based SLO: ${file##*/}"
  fi
done

# Get a list of all slos
ALL_SLOS=$(
    ${CMD_CURL} -X GET "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} '.data[].name'
)

# Read files in JSON_DIR and use jq to get slo name.
# Check if the slo already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for file in ${JSON_DIR}/*.json
do
  SLO=$( ${CMD_JQ} '.name' ${file} )
  if [[ ${ALL_SLOS} =~ ${SLO} ]]
  then
    echo "SLO exists: ${SLO}"
  else
    ${CMD_CURL} -X POST "${API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${file}
    
    echo "SLO created: ${SLO}"
  fi
done
