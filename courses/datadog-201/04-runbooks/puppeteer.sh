#!/bin/bash

apt-get update && apt-get install -y curl

checkStoredog() {
  curl --silent --fail $STOREDOG_URL 2>&1 |grep -qi storedog
}

printf "\nWaiting for Storedog"

until checkStoredog; do
  printf .
  sleep 2
done

printf "\nInfinite Mobile Replay Starting.\n\n"

while :
do
  node puppeteer.js $STOREDOG_URL
done