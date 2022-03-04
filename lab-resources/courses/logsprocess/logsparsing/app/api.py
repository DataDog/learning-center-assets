import blinker as _
import requests

from flask import Flask, Response
from flask import jsonify
from flask import request as flask_request

from ddtrace import tracer
from ddtrace.contrib.flask import TraceMiddleware

# Tracer configuration
tracer.configure(hostname='datadog')


app = Flask('API')
traced_app = TraceMiddleware(app, tracer, service='thinker-api')

@app.route('/think/')
def think_handler():
    
    thoughts = requests.get('http://thinker:8000/', headers={
        'x-datadog-trace-id': str(tracer.current_span().trace_id),
        'x-datadog-parent-id': str(tracer.current_span().span_id),
    }, params={
        'subject': flask_request.args.getlist('subject', str),
    }).content

    return Response(thoughts, mimetype='application/json')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
