#!/bin/bash
# Description: This script will install the zabbix agent on a Datto backup appliance
# Author: Chris Sabo (https://github.com/csabo) / 05.02.2014
# Requirements: Tested on multiple Datto appliances. the root password provided very well may not be the standard forever. so YMMV

logFile="/var/log/zabbix/zabbix-agentd.log"
agentConfig="/etc/zabbix/zabbix_agentd.conf"
zabbixServer="IP or Hostname"

# ensure we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   echo "enter: su backup-admin password is chairs584"
   echo "then sudo su"
   exit 1
fi

# install zabbix agent
apt-get -q -y install zabbix-agent

# create log files
mkdir -p /var/log/zabbix/
touch "$logFile"
chown zabbix "$logFile"

# generate the zabbix agentd config
echo > "$agentConfig"
echo -e "Server=$zabbixServer" >> "$agentConfig"
echo -e "Hostname=$(echo $HOSTNAME)" >> "$agentConfig"
echo -e "LogFile=$("$logFile")" >> "$agentConfig"
echo "LogfileSize=2" >> "$agentConfig"

# start agent
update-rc.d zabbix-agent start 20 3 4 5
/etc/init.d/zabbix* start