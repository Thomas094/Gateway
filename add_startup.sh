#!/bin/bash
# File              : add_startup.sh
# Author            : neal 
# Date              : 05.02.2018
# Last Modified Date: 05.02.2018
# Last Modified By  : neal 
# Note: run as root

chmod 755 keepconnection.sh
ln -s ./keepconnection.sh /etc/init.d/keepconnection 
ln -s /etc/init.d/keepconnection /etc/rc3.d/S80keepconnection 
