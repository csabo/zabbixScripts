#!/bin/bash
# Description: This script is used to check zabbix hosts for RBL entries. It iterates over 'rbl.txt' also found on my github.
# Author: Chris Sabo (https://github.com/csabo) / 12.20.2014
# Requirements: bash, dig, create an external check in zabbix (eg:rbl_ip_check[])
domainIndex=0
result=
mx_list=()
ip_list=()
ip_array=()
domain_array=()
current_domain=
rblIterator=0

# Build array of initial dig return
while read -r _ name; do
    mx_list+=("$name")
done < <(dig $1 mx +short)

# Build array of IPs returned from dig
while read -r ip; do
    ip_list+=("$ip")
done < <(dig "${mx_list[@]}" +short)

# Generate reverseIP array from ip_list
for ip in "${ip_list[@]}"; do
    reverse_ip=$(printf '%s\n' "$ip". | tac -s'.')
    ip_array+=("$reverse_ip")
done

# Build array of RBLs
while read -r line; do
    domain_array+=("$line")
done < /etc/zabbix/externalscripts/rbl.txt

# Iterate over each reversed IP and dig against the provided domain
for p in "${ip_array[@]}"; do
    for z in "${domain_array[@]}"; do
        var=$p$z
        dig $var |grep NOERROR 1>/dev/null && echo ""${ip_list[@]}" Blacklisted by "$z"" && ((rblIterator++))
    done
done

# If not present on any blacklist, echo that out
if [[ $rblIterator == 0 ]]; then
    echo "Not in any blacklist"
fi
