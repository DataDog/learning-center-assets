# uncomment below for arm container (runs on macos w/ no issues)
#FROM arm64v8/python:3.7.0-alpine3.8
FROM python:3.7.0-alpine3.8
RUN apk add build-base eudev-dev openzwave openzwave-dev cython postgresql-dev linux-headers
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
# uncomment below to build zwave for ARM, also add Cython back into requirements
# RUN pip install python_openzwave --no-deps --no-cache-dir --install-option="--flavor=shared"
COPY . /app
CMD ["ddtrace-run", "flask", "run", "--host=0.0.0.0"]