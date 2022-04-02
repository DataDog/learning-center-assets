from wsgiref.simple_server import make_server

import falcon
from falcon_caching import Cache
import uuid
import os

from ddtrace import tracer
from ddtrace.contrib.falcon import TraceMiddleware

tracer.configure(hostname=os.getenv('DD_HOSTNAME', 'api-course-host'))

cache = Cache(
    config={
        'CACHE_TYPE': 'redis',
        'CACHE_EVICTION_STRATEGY': 'time-based',
        'CACHE_REDIS_HOST': 'redis-session-cache',  
        'CACHE_KEY_PREFIX': 'stately'  # default: None
    })

class DefaultResource:
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200 
        resp.content_type = "text/html"
        with open('index.html', 'r') as f:
          resp.text = f.read()

@cache.cached(timeout=600)
class StateResource:
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200  
        # @todo search the data store for the user and return the user and state
        resp.text = '{{ "user": "{}", "state": "010101010" }}'.format(uuid.uuid1())

    def on_post(self, req, resp):
        resp.status = falcon.HTTP_200  
        # @todo write the data store for the user and return the user and state
        resp.text = '{{ "user": "{}", "state": "010101010" }}'.format(uuid.uuid1())

app = falcon.App(middleware=[TraceMiddleware(tracer, 'stately-app'), cache.middleware])

app.add_route('/', DefaultResource())
app.add_route('/state', StateResource())

"""
@todo use the python logging library to log instead of stderr, as described 
[here](https://stackoverflow.com/questions/31433682/control-wsgiref-simple-server-log/31904641#31904641).
Override the default handler WSGIRequestHandler.log_message() to use the python 
logging library. This might enable log<->trace correlation in Datadog, if I understand
[these docs](https://docs.datadoghq.com/tracing/connect_logs_and_traces/python/)
correctly.
"""

if __name__ == '__main__':
    with make_server('', 8000, app) as httpd:
        print('Serving on port 8000...')

        # Serve until process is killed
        httpd.serve_forever()