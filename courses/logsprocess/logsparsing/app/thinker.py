import asyncio
import logging
import pickle

import redis

from aiohttp import web

from ddtrace import tracer, patch
from ddtrace.contrib.aiohttp import trace_app

from thoughts import thoughts

# Logger configuration
logger = logging.getLogger(__name__)

# Setup access logging
aiohttp_logger = logging.getLogger('aiohttp.access')
aiohttp_logger.addHandler(logging.StreamHandler())
aiohttp_logger.setLevel(logging.DEBUG)

# Tracer configuration
tracer.configure(hostname='datadog')

# Configure Redis
# This will report a span with the default settings
redis_client = redis.StrictRedis(host='docdb', port=6379)
patch(redis=True)


@tracer.wrap(name='think')
async def think(subject):
    #redis_client.incr('hits')
    #aiohttp_logger.info('Number of hits is {}' .format(redis_client.get('hits').decode('utf-8')))
    tracer.current_span().set_tag('subject', subject)
    cached_thought = redis_client.get(subject)
    
    if cached_thought:
        return pickle.loads(cached_thought)

    await asyncio.sleep(0.5)

    thought = thoughts[subject]
    redis_client.set(subject, pickle.dumps(thought))

    return thought


async def handle(request):
    response = {}
    
    for subject in request.query.getall('subject', []):
        
        try:
            thought = await think(subject)
            response[subject] = {
                'error': False,
                'quote': thought.quote,
                'author': thought.author,
            }
        except KeyError:
            response[subject] = {
                'error': True,
                'reason': 'This subject is too complicated to be resumed in one sentence.'
            }

    return web.json_response(response)


app = web.Application()
app.router.add_get('/', handle)

trace_app(app, tracer, service='thinker-microservice')
app['datadog_trace']['distributed_tracing_enabled'] = True
web.run_app(app, port=8000)