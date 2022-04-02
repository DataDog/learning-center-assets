#!/usr/bin/env python3
import os
from datetime import *
from dateutil.tz import tzlocal
from datadog_api_client.v1 import ApiClient, ApiException, Configuration
from datadog_api_client.v1.api import logs_api
from datadog_api_client.v1.models import *
from pprint import pprint

configuration = Configuration()

environment=os.getenv('DD_ENV')
host=os.getenv('DD_HOSTNAME')

one_hour_ago=timedelta(seconds=3600)
now=datetime.now(timezone.utc)

with ApiClient(configuration) as api_client:
    api_instance = logs_api.LogsApi(api_client)
    body = LogsListRequest(
	query="env:{env} AND service:lab AND host:{host}".format(env=environment, host=host),
        time=LogsListRequestTime(
            _from=now-one_hour_ago,
            to=now
        )
    )

    try:
        # Send logs
        api_response = api_instance.list_logs(body)
        pprint(api_response)
    except ApiException as e:
        print("Exception when calling LogsApi->list_log: %s\n" % e)
