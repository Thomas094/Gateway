#!/bin/bash
# File              : keepconnection.sh
# Author            : orglanss <orglanss@gmail.com>
# Date              : 22.09.2017
# Last Modified Date: 08.11.2017
# Last Modified By  : orglanss <orglanss@gmail.com>
# This script try to keep the connection to the internet
# NOTE              : Run with sudo


IP="115.156.156.183"
# reconnect internet and output ipaddress using stdout 
function reconnect(){
mentohust -k1 -b3
# wait for connection finished
sleep 2
cat /tmp/mentohust.log|grep '使用IP'|\
grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|sed -n '2p'
}

# upload ipaddress to github
# param1 is ipaddress
function upload(){
ipaddr=$1
./update.sh ${ipaddr}
}

while ((1));
do
{
# test connection stat
  connected=$(ping -w 4 baidu.com 2>&1| grep "100% packet loss\|unknown host" ); 
  if [ ! -z "${connected}" ]; then
    echo "reconnecting ...."
    newIP=`reconnect`
    # if ip changed, upload the new ip address to githup
    if [ ! -z ${newIP} ] && [ ${newIP} != ${IP} ];then
      echo Current IP:${newIP}
      IP=${newIP}
      upload ${IP}
    fi      
  else
    echo "connection is good"
  fi
# wait for a minute befor test connection again
  sleep 60
}
done
