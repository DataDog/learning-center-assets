curl -X POST "https://api.datadoghq.com/api/v1/synthetics/tests/browser" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-d @/root/browser_test.json | jq
