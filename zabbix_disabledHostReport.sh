#!/bin/bash
# Emails out any hosts that are currently disabled, in Maintenance, or still in unsorted
# Author: Chris Sabo (https://github.com/csabo) / 20.03.2014
#Requirements: Tested on Zabbix 1.8.x

sqlUser=""
sqlPass=""
emailAddress=""

disabledHosts=$(mysql -u $sqlUser -p$sqlPass -e "use zabbix;select host from hosts where status = 1;" | tail -n +2)
maintenanceHosts=$(mysql -u $sqlUser -p$sqlPass -e "use zabbix;select host from hosts where maintenance_status = 1;" | tail -n +2)
unsortedHosts=$(mysql -u $sqlUser -p$sqlPass -e "use zabbix;select host from hosts where hosts.hostid in (select hostid from hosts_groups where groupid = 85);" | tail -n +2)

if [ -z "$disabledHosts" ]; then
	exit 0
else
        echo "$disabledHosts" | mail -s "Zabbix - Disabled hosts" $emailAddress
fi

if [ -z "$maintenanceHosts" ]; then
	exit 0
else
	echo "$maintenanceHosts" | mail -s "Zabbix - Hosts still in maintenance" $emailAddress
fi

if [ -z "$unsortedHosts" ]; then
	exit 0
else
	echo "$unsortedHosts" | mail -s "Zabbix - Hosts still in unsorted" $emailAddress
fi