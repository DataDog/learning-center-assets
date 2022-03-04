#!/usr/bin/sh
export DRONE_TOKEN=$(sqlite3 droneio.database.sqlite "select user_hash from users")
export DRONE_SERVER=http://localhost:8800
drone secret add --repository labuser/discounts-service --name DD_API_KEY --data $DD_API_KEY
drone secret add --repository labuser/discounts-service --name DD_APP_KEY --data $DD_APP_KEY
drone secret add --repository labuser/discounts-service --name DD_TEST_PUBLIC_ID --data $DD_TEST_PUBLIC_ID
