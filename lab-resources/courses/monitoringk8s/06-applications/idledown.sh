#!/bin/bash
#
# This is scheduled in CRON using ROOT, it runs every 5 minutes 
# and uses who -a to determine user activity. Once the idle time is
# more than the threshold value it shuts the system down.
#
threshold=10
log=/home/ubuntu/idledown.log
userid=root
inactive=`who -a | grep $userid | cut -c 45-46 | sed 's/ //g'`

if [ "$inactive" != "" ]; then

wall -n "Idle time is: " $inactive

if [ "$inactive" -gt "$threshold" ]; then
wall -n "Threshold met so issuing shutdown command"
/sbin/shutdown -h now
else
echo "Bellow threshold"
fi
else
echo "Idle time is: 0"
fi 

echo "Ending"
