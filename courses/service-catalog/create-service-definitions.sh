#!/bin/bash

# Declare some variables ahead of time
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
CMD_SED="/usr/bin/sed"
JSON_DIR="/root/dashboards/" # location of json files
SERVICE_FILE="/root/lab/service_definitions/services.datadog.yaml"
DASHBOARD_API_URL="https://api.datadoghq.com/api/v1/dashboard" # dashboard
SERVICE_API_URL="https://api.datadoghq.com/api/v2/services/definitions" # service definition

# Get url for Storedog 2.0 dashboard
DASHBOARD_URL=$(
    ${CMD_CURL} -X GET "${DASHBOARD_API_URL}" \
    -H "Accept: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} --raw-output '.dashboards[].url'
)

# Update service definition with the dashboard url
${CMD_SED} -i 's+/UPDATE_URL+'${DASHBOARD_URL}'+g' ${SERVICE_FILE}

# Create Service Definitions
${CMD_CURL} -X POST "${SERVICE_API_URL}" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-T ${SERVICE_FILE}