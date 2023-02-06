#!/bin/sh

## json-request-body
# 
# Curl command
echo "creating monitor 'Resource spree::homecontroller_index has a high p99 latency on env:ruby-shop'"
curl -X POST "https://api.datadoghq.com/api/v1/monitor" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-d @- << EOF
{
	"name": "Resource spree::homecontroller_index has a high p99 latency on env:ruby-shop",
	"type": "query alert",
	"query": "avg(last_5m):p99:trace.rack.request{env:ruby-shop,resource_name:spree::homecontroller_index,service:store-frontend} > 5",
	"message": "The p99 latency of the home page is higher than 5 seconds. \nCurrent p99 value: {{value}}",
	"tags": [
		"env:ruby-shop",
		"service:store-frontend",
		"resource_name:spree::homecontroller_index"
	],
	"options": {
		"thresholds": {
			"critical": 5
		},
		"notify_audit": false,
		"notify_no_data": false,
		"renotify_interval": 0,
		"new_host_delay": 300,
		"include_tags": true,
		"silenced": {}
	},
	"priority": 1,
	"restricted_roles": null
}
EOF
echo "done creating monitor."
