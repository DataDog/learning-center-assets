#!/usr/bin/env python3

import os
import time
from datadog import initialize, api

initialize()

""" Prepare context variables
"""
environment=os.getenv('DD_ENV')
host=os.getenv('DD_HOSTNAME')
service=os.getenv('DD_SERVICE')

tags = [ 'env:{tag}'.format(tag=environment),
         'service:{tag}'.format(tag=service),
         'host:{tag}'.format(tag=host)
]

q_metric=os.getenv('DD_QUERY_METRIC')
query='avg:{metric}{{{tags}}}'.format(metric=q_metric, tags=','.join(tags))

""" Poll the API for service metrics
"""
print('Waiting for {service}'.format(service=service))
service_up=False
while not service_up:
    end_time=int(time.time())
    start_time=end_time - 120
    response=api.Metric.query(start=start_time, end=end_time, query=query)
    service_up=len(response['series']) > 0
    time.sleep(2)
print('{service} is up. Sending event.'.format(service=service))

""" Send event
"""
event_title='{service} is up'.format(service=service)
event_text='The service polling script detected {metric} from {env} on {host} 🐍'.format(
    metric=q_metric, env=environment, host=host
)
event_response=api.Event.create(title=event_title, text=event_text, tags=tags)

if event_response['status'] == "ok":
    print('Event sent OK')
else:
    print('Event not sent')
