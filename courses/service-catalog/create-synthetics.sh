#!/bin/bash

# Declare some variables ahead of time
declare -A GLOBAL_VAR_ARRAY
declare -A GLOBAL_ID_ARRAY
ALL_GLOBAL_VARS=""
ALL_TESTS=""
TEST=""
CMD_JQ="/usr/bin/jq"
CMD_CURL="/usr/bin/curl -sS -L"
JSON_DIR="/root/synthetic_tests" # location of json files
GLOBAL_VAR_API_URL="https://api.datadoghq.com/api/v1/synthetics/variables"
LIST_TESTS_URL="https://api.datadoghq.com/api/v1/synthetics/tests" # List all Synthetic tests
CREATE_API_URL="https://api.datadoghq.com/api/v1/synthetics/tests/api" # Create API test
# The Global Variables we want to create
GLOBAL_VAR_ARRAY=(
    ["HOSTNAME"]=${HOSTNAME}
    ["PARTICIPANT_ID"]=${INSTRUQT_PARTICIPANT_ID}
    ["ADS_PORT"]=${ADS_PORT}
    ["DISCOUNTS_PORT"]=${DISCOUNTS_PORT}
)

# Get a list of existing global variables
ALL_GLOBAL_VARS=$(
    ${CMD_CURL} -X GET "${GLOBAL_VAR_API_URL}" \
    -H "Accept: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
)

# get the ids for existing global variables
# use the key from GLOBAL_VAR_ARRAY to find id
# assign the id value to same key name in GLOBAL_ID_ARRAY
for key in "${!GLOBAL_VAR_ARRAY[@]}"
do
  GLOBAL_ID_ARRAY[$key]=$(
    ${CMD_JQ} --null-input --raw-output --argjson data "${ALL_GLOBAL_VARS}" \
    '$data.variables[] | select(.name=="'$key'").id'
  )
done

# function to create or update variable value
create_update_global_var() {
    NAME=$1
    VALUE=$2
    ID=$3
    METHOD="POST"
    ACTION="created"
    if [[ ! -z ${ID} ]]
    then
      METHOD="PUT"
      ACTION="updated"
    fi
    
    ${CMD_CURL} -X ${METHOD} "${GLOBAL_VAR_API_URL}/${ID}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @- << EOF
    {
      "description": "Instruqt lab ${NAME}",
      "name": "${NAME}",
      "tags": [],
      "value": {
        "secure": false,
        "value": "${VALUE}"
      }
    }
EOF

    echo "Variable ${ACTION}: ${NAME} with value: ${VALUE}"
}


# Check if global variable exists. Create or update as needed
# If a variable exists it will ALWAYS be updated
for key in ${!GLOBAL_VAR_ARRAY[@]}
do
  if [[ ${ALL_GLOBAL_VARS} =~ "$key" ]]
  then
    echo "Variable exists: $key"
    create_update_global_var $key ${GLOBAL_VAR_ARRAY[$key]} ${GLOBAL_ID_ARRAY[$key]}
  else
    create_update_global_var $key ${GLOBAL_VAR_ARRAY[$key]}
  fi
done

# Update global variable ids in the synthetic test json files
# Loop over all synthetic test json files
for file in ${JSON_DIR}/*.json
do
  # Create an array for global variables used in the test
  TEMP_ARRAY=$(
    ${CMD_JQ} --raw-output '.config.configVariables[].name' ${file}
  )

  # Loop the temp array and use matching keys for GLOBAL_ID_ARRAY
  for key in ${TEMP_ARRAY[@]}
  do
    # A temp file is needed to hold results before overwrting the file
    TEMP_FILE=$(mktemp)

    ${CMD_JQ} --arg newid "${GLOBAL_ID_ARRAY[$key]}" \
    '(.config.configVariables[] | select(.name=="'$key'").id) |= $newid' \
    ${file} > ${TEMP_FILE} && \
    mv -- "${TEMP_FILE}" ${file}
  done
done

# Give global vars time to create
sleep 3

# Get a list of all tests
ALL_TESTS=$(
    ${CMD_CURL} -X GET "${LIST_TESTS_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    | ${CMD_JQ} '.tests[].name'
)

# Read files in JSON_DIR and use jq to get test name.
# Check if the test already exists. This avoids duplicates when the lab is ran multiple times.
# If it doesn't exist, create it.
for file in ${JSON_DIR}/*.json
do
  TEST=$( ${CMD_JQ} '.name' ${file} )
  if [[ ${ALL_TESTS} =~ ${TEST} ]]
  then
    echo "Test exists: ${TEST}"
  else
    ${CMD_CURL} -X POST "${CREATE_API_URL}" \
    -H "Content-Type: application/json" \
    -H "DD-API-KEY: ${DD_API_KEY}" \
    -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
    -d @${file}

    echo "Test created: ${TEST}"
  fi
done
