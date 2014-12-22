#!/bin/bash
# Description: This script checks for an SPF record against the provided domain
# Author: Chris Sabo (https://github.com/csabo) / 12.20.2014
# Requirements: bash, dig
spfCheck=$(dig $1 txt +short |grep v=spf)

if [[ $spfCheck ]]
then
        echo $spfCheck
else
        echo "No SPF Record Found"
fi
