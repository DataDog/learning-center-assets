import os
import sys
from time import sleep
import requests
import json
from datadog_api_client.v1 import ApiClient as ApiClientV1, ApiException as ApiExceptionV1, Configuration as ConfigurationV1
from datadog_api_client.v1.api import monitors_api, dashboards_api
from datadog_api_client.v1.models import *
from datadog_api_client.v2 import ApiClient, ApiException, Configuration
from datadog_api_client.v2.api import users_api
from datadog_api_client.v2.models import *
from rich.console import Console

lab_user_email = os.getenv("LABUSER")
api_key = os.getenv("DD_API_KEY")
app_key = os.getenv("DD_APP_KEY")
dashboard_json_path = "/root/storedog-frontend-dashboard.json"

def extend_email(email, extension):
    email_parts = email.split("@")
    return "{start}+{insert}@{end}".format(start=email_parts[0], insert=extension, end=email_parts[1])

def find_dashboard(dashboard_name):
    configuration = ConfigurationV1()
    with ApiClientV1(configuration) as api_client:
        api_instance = dashboards_api.DashboardsApi(api_client)
        try:
            api_response = api_instance.list_dashboards()
            for dashboard in api_response.dashboards:
                if dashboard.title == dashboard_name:
                    return dashboard
            return False
        except ApiException as e:
            print("Exception when searching for monitor: {0}".format(e))
            sys.exit(1)

def create_dashboard(json_path, api_key, app_key):
    """
    It's much easier to create a Dashboard from exported JSON than to use the client libs :)
    """
    url = "https://api.datadoghq.com/api/v1/dashboard"
    headers= {
        'DD-API-KEY': api_key,
        'DD-APPLICATION-KEY': app_key,

         }
    try:
        contents = open(json_path, 'rb').read()
        r = requests.post(url, json=json.loads(contents), headers=headers)
        if r.status_code == requests.codes.ok:
            return r.json()
    except Exception as e:
        print("Exception when creating dashboard: {0}".format(e))
        sys.exit(1)


def find_monitor(monitor_name):
    configuration = ConfigurationV1()
    with ApiClientV1(configuration) as api_client:
        api_instance = monitors_api.MonitorsApi(api_client)
        try:
            api_response = api_instance.search_monitors(query=monitor_name)
            return api_response.metadata.total_count > 0
        except ApiException as e:
            print("Exception searching for monitor: {0}".format(e))
            sys.exit(1)

def create_monitor(monitor_name, dashboard_url):
    configuration = ConfigurationV1()
    with ApiClientV1(configuration) as api_client:
        api_instance = monitors_api.MonitorsApi(api_client)
        body = Monitor(
            message="`store-frontend` average latency is too high. Consult the [Storedog Dashboard]({0}) for more information".format(dashboard_url),
            name=monitor_name,
            options=MonitorOptions(
                notify_audit=False,
                locked=False,
                timeout_h=0,
                new_host_delay=300,
                require_full_window=False,
                notify_no_data=False,
                renotify_interval=0,
                escalation_message="",
                no_data_timeframe=None,
                include_tags=True,
                thresholds=MonitorThresholds(
                    critical=2.0
                )
            ),
            query="avg(last_1m):avg:trace.rack.request{env:im-workshop,resource_name:spree::homecontroller_index,service:store-frontend} > 2",
            tags=["service:store-frontend", "env:im-workshop", "resource_name:spree::homecontroller_index"],
            type=MonitorType("metric alert")
        )
        try:
            # Create a monitor
            api_response = api_instance.create_monitor(body)
            return api_response.id
        except ApiException as e:
            print("Exception creating monitor: {0}\n".format(e))
            sys.exit(1)


console = Console()
monitor_name = "Monitor for Incident Management Workshop"
dashboard_name = "Storedog Frontend Dashboard"
dashboard = {}

with console.status("Creating dashboard") as status:
    dashboard = find_dashboard(dashboard_name)
    if not dashboard:
        dashboard = create_dashboard(dashboard_json_path, api_key, app_key)
        console.log("Dashboard id {0} [green]created[/green]".format(dashboard["id"]))
    else:
        console.log(dashboard_name, "[green]exists[/green]")

    status.update("Creating monitor")
    if not find_monitor(monitor_name):
        monitor_id = create_monitor(monitor_name, dashboard["url"])
        console.log("Monitor id {0} [green]created[/green]".format(monitor_id))
    else:
      console.log("Monitor [green]exists[/green]")
