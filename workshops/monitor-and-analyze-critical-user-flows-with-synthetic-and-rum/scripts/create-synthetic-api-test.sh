#!/usr/bin/env bash

function create_synthetic_api_test () {
  local data

  function construct_api_url () {
    echo "https://api.datadoghq.com/api$1"
  }

  function datadog_api_post_helper () {
    local url

    url=$(construct_api_url "$1")

    # make request to URL provided as $1
    curl --silent --output /dev/null -X POST "$url" \
      -H "Content-Type: application/json" \
      -H "DD-API-KEY: ${DD_API_KEY}" \
      -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
      --data "$2"
  }

  function create_test() {
    datadog_api_post_helper "/v1/synthetics/tests" "$1"
  }

  if [ -z "$DD_API_KEY" ]; then
    echo "DD_API_KEY environment variable not found."

    return 1
  fi

  if [ -z "$DD_APP_KEY" ]; then
    echo "DD_APP_KEY environment variable not found."

    return 1
  fi

  data=$(cat "/root/assets/synthetic-api-test.json")

  create_test "$data"
}

create_synthetic_api_test
