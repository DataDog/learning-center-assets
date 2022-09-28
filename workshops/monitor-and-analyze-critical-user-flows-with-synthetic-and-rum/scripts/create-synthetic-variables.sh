#!/usr/bin/env bash

# Because it can be hard to figure out what some of the URLs are - and in various
# situations they can change we're going to give the workshop participants a simple
# variable to use them in their Synthetic API tests
function synthetic_variables () {
  synthetic_variable "STOREDOG_URL" "$STOREDOG_FE_URL" "Storedog URL for Monitoring User Flows Dash Workshop"
  synthetic_variable "STOREDOG_API_URL" "$STOREDOG_BE_URL" "Storedog API URL for Monitoring User Flows Dash Workshop"
  synthetic_variable "STOREDOG_ADS_URL" "$ADS_URL" "Storedog Ads Service URL for Monitoring User Flows Dash Workshop"
}

synthetic_variables
