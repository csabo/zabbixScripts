#!/bin/bash
# Description: This script checks the provided domain for an ssl cert, and returns its expiration date
# Author: Chris Sabo (https://github.com/csabo) / 12.20.2014
# Requirements: bash, openssl
SERVER=$1
PORT=${2:-443}
TIMEOUT=25
end_date="$(/usr/bin/timeout $TIMEOUT /usr/bin/openssl s_client -host $SERVER -port $PORT -showcerts < /dev/null 2>/dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -enddate -noout 2>/dev/null | sed -e 's/^.*\=//')"

if [ -n "$end_date" ]
then
end_date_seconds=$(date "+%s" --date "$end_date")
now_seconds=$(date "+%s")
CALC=$((($end_date_seconds-$now_seconds)/24/3600))
echo $CALC
else
exit 124
fi
