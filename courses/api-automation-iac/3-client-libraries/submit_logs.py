#!/usr/bin/env python3
import os
from datadog_api_client.v1 import ApiClient, ApiException, Configuration
from datadog_api_client.v1.api import logs_api
from datadog_api_client.v1.models import *

configuration = Configuration()

environment=os.getenv('DD_ENV')
host=os.getenv('DD_HOSTNAME')

with ApiClient(configuration) as api_client:
    api_instance = logs_api.LogsApi(api_client)
    body = HTTPLog([
        HTTPLogItem(
            ddsource="python",
            ddtags="env:{env}".format(env=environment),
            hostname=host,
            message="This log entry was sent with a python script!",
            service="lab",
        ),
        HTTPLogItem(
            ddsource="python",
            ddtags="env:{env}".format(env=environment),
            hostname=host,
            message="This is ANOTHER log entry that was sent with a python script!",
            service="lab",
        )
    ])

    try:
        # Send logs
        api_response = api_instance.submit_log(body)
        print("Log entries sent OK.")
    except ApiException as e:
        print("Exception when calling LogsApi->submit_log: %s\n" % e)
