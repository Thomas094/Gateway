#!/bin/bash
# File              : keepconnection.sh
# Author            : orglanss <orglanss@gmail.com>
# Date              : 22.09.2017
# Last Modified Date: 01.02.2018
# Last Modified By  : neal <orglanss@gmail.com>
# This script try to keep the connection to the internet
# NOTE              : Run with sudo


IP="115.156.156.183"
UPLOAD_SUCCESS=true
# reconnect internet and output ipaddress using stdout 
function reconnect(){
mentohust -k1 -b3
# wait for connection finished
sleep 10
cat /tmp/mentohust.log|grep '使用IP'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|sed -n '2p'
}

# upload ipaddress to github
# param1 is ipaddress
function upload(){
ipaddr=$1
if [ -z `./update.sh ${ipaddr}|grep "fatal\|error"` ];then
  UPLOAD_SUCCESS=true;
else
  UPLOAD_SUCCESS=false;
fi
}

while (true);
do
{
  # test connection stat
  connected=$(ping -w 4 baidu.com 2>&1| grep "100% packet loss\|unknown host" ); 
  if [ ! -z "${connected}" ]; then
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    echo "${DATE} reconnecting ...."
    curIP=`reconnect`
    while [ -z ${curIP} ]
    do
      # get ip failed, retry 
      curIP=`reconnect`
    done
    # if ip changed, upload the new ip address to github
    if [ ${curIP} != ${IP} ];then
      echo Current IP:${curIP}
      IP=${curIP}
      upload ${IP}
    fi 
  fi
       
  # if upload failed, retry
  if [ ! ${UPLOAD_SUCCESS} ]; then
    upload ${IP}
  fi
  # wait for a minute before test connection again
  sleep 60
}
done
