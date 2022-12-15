# Curl command
echo "creating dashboard 'Storedog SLOs'"
curl -X POST "https://api.datadoghq.com/api/v1/dashboard" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
-d @- << EOF
{
	"title": "Storedog SLOs",
	"description": "",
	"widgets": [{
		"id": 5838877662235490,
		"definition": {
			"title": "SLOs",
			"type": "group",
			"show_title": true,
			"layout_type": "ordered",
			"widgets": [{
				"id": 4154764459751438,
				"definition": {
					"type": "free_text",
					"text": "Please add your SLO and Monitor Widgets here",
					"color": "#4d4d4d",
					"font_size": "auto",
					"text_align": "left"
				},
				"layout": {
					"x": 0,
					"y": 0,
					"width": 2,
					"height": 1
				}
			}]
		},
		"layout": {
			"x": 0,
			"y": 0,
			"width": 12,
			"height": 2
		}
	}, {
		"id": 7389644043635170,
		"definition": {
			"title": "Golden Signals",
			"type": "group",
			"show_title": true,
			"layout_type": "ordered",
			"widgets": [{
				"id": 2040229312110006,
				"definition": {
					"title": "Saturation",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"response_format": "scalar",
						"queries": [{
							"name": "query1",
							"data_source": "metrics",
							"query": "avg:system.cpu.user{*}",
							"aggregator": "avg"
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"type": "area"
					}
				},
				"layout": {
					"x": 0,
					"y": 0,
					"width": 2,
					"height": 2
				}
			}, {
				"id": 3567145269162582,
				"definition": {
					"title": "Latency",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"response_format": "scalar",
						"queries": [{
							"data_source": "spans",
							"name": "query1",
							"search": {
								"query": ""
							},
							"indexes": ["trace-search"],
							"compute": {
								"aggregation": "avg",
								"metric": "@duration"
							},
							"group_by": []
						}],
						"formulas": [{
							"formula": "query1"
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"type": "area",
						"yaxis": {
							"include_zero": true
						}
					}
				},
				"layout": {
					"x": 2,
					"y": 0,
					"width": 2,
					"height": 2
				}
			}, {
				"id": 6085708544528828,
				"definition": {
					"title": "",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"response_format": "scalar",
						"queries": [{
							"data_source": "metrics",
							"name": "query1",
							"query": "sum:trace.rack.request.hits{*}.as_count()",
							"aggregator": "avg"
						}],
						"formulas": [{
							"formula": "query1"
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"type": "bars"
					}
				},
				"layout": {
					"x": 4,
					"y": 0,
					"width": 2,
					"height": 2
				}
			}]
		},
		"layout": {
			"x": 0,
			"y": 2,
			"width": 12,
			"height": 3
		}
	}, {
		"id": 2005034165622288,
		"definition": {
			"title": "Performance Overview",
			"type": "group",
			"show_title": true,
			"layout_type": "ordered",
			"widgets": [{
				"id": 1001066402800514,
				"definition": {
					"title": "Store Frontend Performance Overview",
					"time": {},
					"type": "trace_service",
					"env": "ruby-shop",
					"service": "store-frontend",
					"span_name": "rack.request",
					"show_hits": true,
					"show_errors": true,
					"show_latency": true,
					"show_breakdown": true,
					"show_distribution": true,
					"show_resource_list": false,
					"size_format": "medium",
					"display_format": "two_column"
				},
				"layout": {
					"x": 0,
					"y": 0,
					"width": 10,
					"height": 6
				}
			}]
		},
		"layout": {
			"x": 0,
			"y": 5,
			"width": 12,
			"height": 7
		}
	}, {
		"id": 3284792899780590,
		"definition": {
			"title": "Service Dependencies",
			"title_size": "16",
			"title_align": "left",
			"type": "topology_map",
			"requests": [{
				"request_type": "topology",
				"query": {
					"filters": ["env:ruby-shop"],
					"service": "store-frontend",
					"data_source": "service_map"
				}
			}]
		},
		"layout": {
			"x": 0,
			"y": 0,
			"width": 7,
			"height": 4
		}
	}, {
		"id": 4429440597392892,
		"definition": {
			"title": "Log Stream",
			"title_size": "16",
			"title_align": "left",
			"time": {},
			"requests": [{
				"response_format": "event_list",
				"query": {
					"data_source": "logs_stream",
					"query_string": "-service:puppeteer",
					"indexes": []
				},
				"columns": [{
					"field": "status_line",
					"width": "auto"
				}, {
					"field": "timestamp",
					"width": "auto"
				}, {
					"field": "host",
					"width": "auto"
				}, {
					"field": "service",
					"width": "auto"
				}, {
					"field": "content",
					"width": "full"
				}]
			}],
			"type": "list_stream"
		},
		"layout": {
			"x": 7,
			"y": 0,
			"width": 4,
			"height": 4
		}
	}],
	"template_variables": [],
	"layout_type": "ordered",
	"is_read_only": false,
	"notify_list": [],
	"reflow_type": "fixed"
}
EOF
echo "done creating dashboard."