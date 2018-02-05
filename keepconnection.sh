#!/bin/bash
# File              : keepconnection.sh
# Author            : orglanss <orglanss@gmail.com>
# Date              : 22.09.2017
# Last Modified Date: 05.02.2018
# Last Modified By  : neal <orglanss@gmail.com>
# This script try to keep the connection to the internet
# NOTE              : Run with sudo


IP="115.156.156.183"
# whether the upload is succeed
UPLOAD_SUCCESS=true
LOG_FILE=/tmp/keepconnection.log

# change to project directory
cd $(dirname $(realpath $0))
# reconnect internet and output ipaddress using stdout 
function reconnect(){
  mentohust -k1 -b3
# wait for connection finished
  sleep 10
  cat /tmp/mentohust.log|grep '使用IP'|grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'|sed -n '2p'
}

# upload ip address to github
# param1 is ip address
function upload(){
  ipaddr=$1
  if [ -z `./update.sh ${ipaddr} 2>&1|grep "fatal\|error"` ];then
    UPLOAD_SUCCESS=true;
    echo "upload success"
  else
    echo "upload failed"
    UPLOAD_SUCCESS=false;
  fi
}

function keepconnect(){
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
}

while (true);
do
{
  keepconnect >>${LOG_FILE} 2>&1
  # wait for a minute before test connection again
  sleep 60
}
done

