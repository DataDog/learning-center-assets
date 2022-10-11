#!/bin/bash
# This forwards logs from the storedog generator into the Datadog agent
# directly.
/root/lab/bin/storedog-gen 2>&1 | nc localhost 10518 &
disown