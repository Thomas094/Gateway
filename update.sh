#!/bin/bash
# File              : Gateway/update.sh
# Author            : neal
# Date              : 08.11.2017
# Last Modified Date: 08.11.2017
# Last Modified By  : neal

if [ $# != 1 ]; then
  echo Usage: $0 IP
  exit 1
fi

IP=$1

sed -i "3c ## ${IP}" README.md

git add README.md
git commit -m "update automatically"
git push origin master
