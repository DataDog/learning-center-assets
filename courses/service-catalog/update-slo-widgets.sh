#!/bin/bash

# Declare some variables ahead of time
ALL_SLOS=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS"
CMD_SED="/usr/bin/sed -i"
DASHBOARD_FILE="/root/dashboards/Storedog2.0.json" # location of dashboard json file
SLO_API_URL="https://api.datadoghq.com/api/v1/slo"

# Get all SLO data
ALL_SLOS=$(
    ${CMD_CURL} -X GET "${SLO_API_URL}" \
    -H "Accept: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
)

# Get the Java SLO id and replace in dashboard json
JAVA_ID=$(
    ${CMD_JQ} --null-input --raw-output --argjson results "${ALL_SLOS}" \
    '$results.data[] | select(.name | contains("Java")).id'
)

${CMD_SED} 's+JAVA_SLO_ID+'${JAVA_ID}'+g' ${DASHBOARD_FILE}

# Get the Python SLO id and replace in dashboard json
PYTHON_ID=$(
    ${CMD_JQ} --null-input --raw-output --argjson results "${ALL_SLOS}" \
    '$results.data[] | select(.name | contains("Python")).id'
)

${CMD_SED} 's+PYTHON_SLO_ID+'${PYTHON_ID}'+g' ${DASHBOARD_FILE}

# Get the Backend SLO id and replace in dashboard json
BACKEND_ID=$(
    ${CMD_JQ} --null-input --raw-output --argjson results "${ALL_SLOS}" \
    '$results.data[] | select(.name | contains("store-backend")).id'
)

${CMD_SED} 's+BACKEND_SLO_ID+'${BACKEND_ID}'+g' ${DASHBOARD_FILE}
