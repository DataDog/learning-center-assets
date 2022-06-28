import os
import sys
from time import sleep
import requests
import json
from datadog_api_client.v1 import ApiClient as ApiClientV1, ApiException as ApiExceptionV1, Configuration as ConfigurationV1
from datadog_api_client.v1.api import monitors_api, service_level_objectives_api, dashboards_api
from datadog_api_client.v1.models import *
from datadog_api_client.v2 import ApiClient, ApiException, Configuration
from datadog_api_client.v2.api import users_api
from datadog_api_client.v2.models import *
from rich.console import Console

api_key = os.getenv("DD_API_KEY")
app_key = os.getenv("DD_APP_KEY")
monitor_json_path = "/root/monitor.json"
dashboard_json_path = "/root/dashboard.json"

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
            print("Exception when searching for dashboard: {0}".format(e))
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
            if api_response.metadata.total_count > 0:
                monitor = [mon for mon in api_response.monitors if mon['classification'] == 'apm'][0]
                return monitor['id']
            else:
                return 0

        except ApiException as e:
            print("Exception searching for monitor: {0}".format(e))
            sys.exit(1)

def find_slo(slo_name):
    configuration = ConfigurationV1()
    with ApiClientV1(configuration) as api_client:
        api_instance = service_level_objectives_api.ServiceLevelObjectivesApi(api_client)
        try:
            api_response = api_instance.list_slos(query=slo_name)
            if len(api_response.data) > 0:
                slo = api_response.data[0]
                return slo['id']
            else:
                return ''

        except ApiException as e:
            print("Exception searching for SLO: {0}".format(e))
            sys.exit(1)

def create_monitor(json_path):
    configuration = ConfigurationV1()
    contents = open(json_path, 'rb').read()
    with ApiClientV1(configuration) as api_client:
        api_instance = monitors_api.MonitorsApi(api_client)
        try:
            api_response = api_instance.create_monitor(json.loads(contents))
            return api_response.id
        except ApiException as e:
            print("Exception creating SLO: {0}\n".format(e))
            sys.exit(1)

def create_slo(slo_name, monitor_id):
    configuration = ConfigurationV1()
    with ApiClientV1(configuration) as api_client:
        api_instance = service_level_objectives_api.ServiceLevelObjectivesApi(api_client)
        body = ServiceLevelObjectiveRequest(
            monitor_ids=[monitor_id],
            name=slo_name,
            thresholds=[
                SLOThreshold(
                    target=99.0,
                    target_display='99.',
                    timeframe=SLOTimeframe('7d')
                )
            ],
            type=SLOType("monitor")
        )
        try:
            api_response = api_instance.create_slo(body)
            return api_response.data[0].id
        except ApiException as e:
            print("Exception creating SLO: {0}\n".format(e))

console = Console()
monitor_name = "Discounts service request time"
slo_name = "Discounts service request time"
dashboard_name = "Datadog 101: SRE Dashboard"
dashboard = {}

with console.status("Creating users") as status:

    status.update("Creating dashboard")
    dashboard = find_dashboard(dashboard_name)
    if not dashboard:
        dashboard = create_dashboard(dashboard_json_path, api_key, app_key)
        console.log("Dashboard id {0} [green]created[/green]".format(dashboard["id"]))
    else:
        console.log(dashboard_name, "[green]exists[/green]")

    status.update("Creating monitor")
    monitor_id = find_monitor(monitor_name)
    if monitor_id > 0:
      console.log("Monitor id {0} [green]exists[/green]".format(monitor_id))

    else:
      monitor_id = create_monitor(monitor_json_path)
      console.log("Monitor id {0} [green]created[/green]".format(monitor_id))
      create_slo(slo_name, monitor_id)

    status.update("Creating SLO")
    slo_id = find_slo(slo_name)
    if slo_id:
        console.log("SLO id {0} [green]exists[/green]".format(slo_id))
    else:
        slo_id = create_slo(slo_name, monitor_id)
        console.log("SLO id {0} [green]created[/green]".format(slo_id))