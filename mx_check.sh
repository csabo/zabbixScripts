#!/bin/bash
# Description: This script is used to check domains for MX records.
# Author: Chris Sabo (https://github.com/csabo) / 12.20.2014
# Requirements: bash, dig, create an external check in zabbix (eg: mx_check["{HOST.HOST}"])
mxCmd=$(dig $1 mx +short | sort -n | tr '\n' ' ')

if [[ -z $mxCmd ]]; then
	sleep 10
	if [[ -z $mxCmd ]]; then
		echo "No MX Record Found"
	fi
else
        printf "$mxCmd"
fi
