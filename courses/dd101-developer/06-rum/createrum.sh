#!/bin/bash
if [ -x "$(command -v jq)" ]; then
  DDRUMINFO=$(curl -X POST "https://api.datadoghq.com/api/v1/rum/projects" -H "Content-Type: application/json" -H "DD-API-KEY: ${DD_API_KEY}" -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" -d '{"name": "Storedog","type": "browser"}')
  export DD_APPLICATION_ID=$(echo $DDRUMINFO|jq -r .application_id)
  export DD_CLIENT_TOKEN=$(echo $DDRUMINFO|jq -r .hash)
else
  echo "jq not installed"
fi