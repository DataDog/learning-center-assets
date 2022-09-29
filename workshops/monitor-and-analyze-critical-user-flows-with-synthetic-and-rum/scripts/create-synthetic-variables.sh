#!/usr/bin/env bash

# Because it can be hard to figure out what some of the URLs are - and in various
# situations they can change we're going to give the workshop participants a simple
# variable to use them in their Synthetic API tests
function synthetic_variables () {

  function synthetic_variable () {
    local VARIABLES

    function construct_api_url () {
      echo "https://api.datadoghq.com/api$1"
    }

    function datadog_api_get_helper () {
      local url

      url=$(construct_api_url "$1")

      # make request to URL provided as $1
      curl --silent "$url" \
        -H "Content-Type: application/json" \
        -H "DD-API-KEY: ${DD_API_KEY}" \
        -H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
    }

    function datadog_api_post_helper () {
      local url

      url=$(construct_api_url "$1")

      # make request to URL provided as $1
      curl --silent -X POST "$url" \
        -H "Content-Type: application/json" \
        -H "DD-API-KEY: ${DD_API_KEY}" \
        -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
        --data "$2"
    }

    function datadog_api_put_helper () {
      local url

      url=$(construct_api_url "$1")

      # make request to URL provided as $1
      curl --silent -X PUT "$url" \
        -H "Content-Type: application/json" \
        -H "DD-API-KEY: ${DD_API_KEY}" \
        -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
        --data "$2"
    }

    function get_synthetic_global_variables () {
      local variables_response

      variables_response=$(datadog_api_get_helper "/v1/synthetics/variables")

      echo "$variables_response"
    }

    VARIABLES=$(get_synthetic_global_variables)

    #adapted from: https://stackoverflow.com/a/17032673/656011
    function create_synthetic_variable_post_data () {
      cat <<EOF
{
  "description": "$3",
  "name": "$1",
  "value": {
    "secure": false,
    "value": "$2"
  },
  "tags": []
}
EOF
    }

    function create_synthetic_variable () {
      local variable_payload

      variable_payload=$(create_synthetic_variable_post_data "$@")

      local new_variable_id

      new_variable_id=$(datadog_api_post_helper "/v1/synthetics/variables" "$variable_payload")

      echo "$new_variable_id"
    }

    function get_variable_id () {
      local variable_id

      variable_id=$(echo "$1" | jq -r ".variables? | .[]? | select(.name==\"$2\")? | .id?")

      echo "$variable_id"
    }

    function check_for_variable_id () {
      local variable_id

      variable_id=$(get_variable_id "$VARIABLES" "$1")

      if [ -z "$variable_id" ]; then
        echo 0
      else
        echo "$variable_id"
      fi
    }

    function create_or_update_synthetic_variable () {
      local variable_id

      if [ -z "$1" ]; then
        echo "Please provide a variable name."

        return 1
      fi

      if [ -z "$2" ]; then
        echo "Please provide a value for your variable."

        return 1
      fi

      variable_id=$(check_for_variable_id "$1")

      if [ "$variable_id" == 0 ]; then
        local variable_request

        variable_request=$(create_synthetic_variable "$@")
        variable_id=$(get_variable_id "$variable_request" "$1")
      else
        local variable_payload

        variable_payload=$(create_synthetic_variable_post_data "$@")

        local variable_request

        variable_request=$(datadog_api_put_helper "/v1/synthetics/variables/$variable_id" "$variable_payload")

        variable_id=$(get_variable_id "$variable_request" "$1")
      fi

      echo "$variable_id"
    }

    create_or_update_synthetic_variable "$@"
  }

  if [ -z "$DD_API_KEY" ]; then
    echo "DD_API_KEY environment variable not found."

    return 1
  fi

  if [ -z "$DD_APP_KEY" ]; then
    echo "DD_APP_KEY environment variable not found."

    return 1
  fi

  synthetic_variable "STOREDOG_URL" "$STOREDOG_FE_URL" "Storedog URL for Monitoring User Flows Dash Workshop"
  synthetic_variable "STOREDOG_API_URL" "$STOREDOG_BE_URL" "Storedog API URL for Monitoring User Flows Dash Workshop"
  # We'll have the workshop attendee make this one manually so they know how it works
  # synthetic_variable "STOREDOG_ADS_URL" "$ADS_URL" "Storedog Ads Service URL for Monitoring User Flows Dash Workshop"
}

synthetic_variables
