#!/bin/bash
# Description: This script is used to check IPs for RBL entries. It iterates over 'rbl.txt' also found on my github.
# Author: Chris Sabo (https://github.com/csabo) / 12.20.2014
# Requirements: bash, dig, create an external check in zabbix (eg:rbl_ip_check[])
domainIndex=0
result=
domain_array=()
current_domain=
rblIterator=0

# Generate reverseIP array from ip_list
reverse_ip=$(printf '%s\n' "$1". | tac -s'.')

# Build array of RBLs
while read -r line; do
    domain_array+=("$line")
done < /etc/zabbix/externalscripts/rbl.txt

# Iterate over each reversed IP and dig against the provided domain
for z in "${domain_array[@]}"; do
    var=$reverse_ip$z
    dig $var |grep NOERROR 1>/dev/null && echo ""$1" blacklisted by "$z"" && ((rblIterator++))
done

# If not present on any blacklist, echo that out
if [[ $rblIterator == 0 ]]; then
    echo "Not in any blacklist"
fi
