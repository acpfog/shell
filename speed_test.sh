#!/bin/bash

# a list of servers
array=( data1 data2 data3 data4 data5 )

# check each server
for server in "${array[@]}"
do
# set variables and print info  
    COUNTER=0
    URL="http://$server.company-domain.com/path/file.bin"
    host $server.company-domain.com
    echo $URL
# getting download time and speed five times and print the result each time
    while [  $COUNTER -lt 5 ]; do
        printf %s "$(date)"
        curl -o /dev/null -sw " time: %{time_total}s speed: %{speed_download} B/s\n" $URL
        let COUNTER=COUNTER+1 
        sleep 5
    done
done
