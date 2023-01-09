# Curl command
echo "creating dashboard 'Storedog SLOs'"
curl -s -X GET "https://api.datadoghq.com/api/v1/dashboard" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}" | grep Storedog >> /dev/null

RC=$?
if [ $RC = 0 ]
then
        echo "Dashboard already exists"
else
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
				"id": 3567145269162582,
				"definition": {
					"title": "Latency",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"formulas": [{
							"formula": "query1"
						}],
						"response_format": "scalar",
						"queries": [{
							"data_source": "spans",
							"name": "query1",
							"search": {
								"query": "service:store-frontend"
							},
							"indexes": ["trace-search"],
							"compute": {
								"aggregation": "avg",
								"metric": "@duration"
							},
							"group_by": []
						}],
						"conditional_formats": [{
							"comparator": "<=",
							"palette": "white_on_green",
							"value": 2500000000
						}, {
							"comparator": "<=",
							"palette": "white_on_yellow",
							"value": 4000000000
						}, {
							"comparator": ">",
							"palette": "white_on_red",
							"value": 4000000000
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"yaxis": {
							"include_zero": true
						},
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
				"id": 6085708544528828,
				"definition": {
					"title": "Traffic",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"formulas": [{
							"formula": "query1"
						}],
						"response_format": "scalar",
						"queries": [{
							"query": "sum:trace.rack.request.hits{*}.as_count()",
							"data_source": "metrics",
							"name": "query1",
							"aggregator": "avg"
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"type": "bars"
					}
				},
				"layout": {
					"x": 2,
					"y": 0,
					"width": 2,
					"height": 2
				}
			}, {
				"id": 2040229312110006,
				"definition": {
					"title": "Error rate (%)",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"response_format": "scalar",
						"queries": [{
							"query": "sum:trace.rack.request.hits{service:store-frontend}.as_count()",
							"data_source": "metrics",
							"name": "query1",
							"aggregator": "avg"
						}, {
							"query": "sum:trace.rack.request.errors{service:store-frontend}.as_count()",
							"data_source": "metrics",
							"name": "query2",
							"aggregator": "avg"
						}],
						"formulas": [{
							"formula": "(query1 - query2) / query1"
						}],
						"conditional_formats": [{
							"comparator": "<=",
							"palette": "white_on_green",
							"value": 0.5
						}, {
							"comparator": "<=",
							"palette": "white_on_yellow",
							"value": 1
						}, {
							"comparator": ">",
							"palette": "white_on_red",
							"value": 1
						}]
					}],
					"autoscale": false,
					"custom_unit": "%",
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
			}, {
				"id": 6237340431729618,
				"definition": {
					"title": "Saturation (CPU %)",
					"title_size": "16",
					"title_align": "left",
					"time": {},
					"type": "query_value",
					"requests": [{
						"response_format": "scalar",
						"queries": [{
							"query": "avg:system.cpu.user{*}",
							"data_source": "metrics",
							"name": "query1",
							"aggregator": "avg"
						}],
						"conditional_formats": [{
							"comparator": "<=",
							"palette": "white_on_green",
							"value": 60
						}, {
							"comparator": "<=",
							"palette": "white_on_yellow",
							"value": 80
						}, {
							"comparator": ">",
							"palette": "white_on_red",
							"value": 80
						}]
					}],
					"autoscale": true,
					"precision": 2,
					"timeseries_background": {
						"type": "area"
					}
				},
				"layout": {
					"x": 6,
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
				"query": {
					"data_source": "service_map",
					"filters": ["env:ruby-shop"],
					"service": "store-frontend"
				},
				"request_type": "topology"
			}]
		},
		"layout": {
			"x": 0,
			"y": 0,
			"width": 7,
			"height": 4
		}
	}, {
		"id": 8780570855631100,
		"definition": {
			"title": "Slowest Resources by Average Latency",
			"title_size": "16",
			"title_align": "left",
			"type": "query_table",
			"requests": [{
				"formulas": [{
					"formula": "query1",
					"conditional_formats": [],
					"limit": {
						"count": 10,
						"order": "desc"
					},
					"cell_display_mode": "bar"
				}],
				"response_format": "scalar",
				"queries": [{
					"search": {
						"query": "service:store-frontend -resource_name:\"GET 500\""
					},
					"data_source": "spans",
					"compute": {
						"metric": "@duration",
						"aggregation": "avg"
					},
					"name": "query1",
					"indexes": ["trace-search"],
					"group_by": [{
						"facet": "resource_name",
						"sort": {
							"metric": "@duration",
							"aggregation": "avg",
							"order": "desc"
						},
						"limit": 10
					}]
				}]
			}],
			"has_search_bar": "auto"
		},
		"layout": {
			"x": 7,
			"y": 0,
			"width": 5,
			"height": 4
		}
	}, {
		"id": 4070530779538830,
		"definition": {
			"title": "Hosts by CPU Utilization",
			"title_size": "16",
			"title_align": "left",
			"type": "hostmap",
			"requests": {
				"fill": {
					"q": "avg:system.cpu.user{*} by {host}"
				}
			},
			"node_type": "host",
			"no_metric_hosts": true,
			"no_group_hosts": true,
			"style": {
				"palette": "green_to_orange",
				"palette_flip": false
			}
		},
		"layout": {
			"x": 0,
			"y": 4,
			"width": 4,
			"height": 4
		}
	}, {
		"id": 4429440597392892,
		"definition": {
			"title": "Log Stream",
			"title_size": "16",
			"title_align": "left",
			"requests": [{
				"query": {
					"query_string": "service:store-frontend",
					"data_source": "logs_stream",
					"indexes": []
				},
				"response_format": "event_list",
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
					"field": "content",
					"width": "full"
				}]
			}],
			"type": "list_stream"
		},
		"layout": {
			"x": 4,
			"y": 4,
			"width": 8,
			"height": 4
		}
	}],
	"template_variables": [],
	"layout_type": "ordered",
	"is_read_only": false,
	"notify_list": [],
	"reflow_type": "fixed",
	"id": "h7u-huv-jnm"
}
EOF
	echo "done creating dashboard."
end