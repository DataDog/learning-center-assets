FROM python:3.7.0-alpine3.8
LABEL maintainer="Datadog Inc. <kirk.kaiser@datadoghq.com>"

# following line needed to build psycopg2
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev linux-headers
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app
CMD ["ddtrace-run", "flask", "run", "--host=0.0.0.0"]