#!/usr/bin/bash

# chmod u+x this file.
# assuming it's located at /root/drive-stately.sh, run with `./root/drive-stately.sh`

STATELY_URL=$(cat /root/stately_url.txt)

spam_stately () {
  wait-for-it --timeout=60 $STATELY_URL
  while true
  do
    curl -s $STATELY_URL > /dev/null
    sleep 1
    curl -s -X POST $STATELY_URL/state \
      -H "Content-Type: application/json" \
      -H "X-Requested-With: cURL" > /dev/null
    sleep 2
  done
}

spam_stately >/dev/null 2>&1 & disown
