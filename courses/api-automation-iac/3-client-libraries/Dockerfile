FROM python:3.9.1-slim-buster

# Update, upgrade, and cleanup debian packages
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade --yes 

# Bring in app
WORKDIR /app
COPY index.html .
COPY stately-server.py .

# Install dependencies via pip and avoid caching build artifacts
RUN pip install --no-cache-dir falcon falcon_caching redis ddtrace

CMD ["ddtrace-run", "python", "stately-server.py"]
