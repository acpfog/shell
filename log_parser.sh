#!/bin/sh

# this script reads lines from an access log file (nginx)
# and counts a number of lines with each unique URI

# check if $1 is set or print usage hint
if [ -n "$1" ]
then

# init an associative array
    declare -A arr
    
# read lines from a file with the name from $1 variable
# explode each line by spaces
# 7th field is uri and 9th is status
# for each status 200 increment a value of the associative array using uri as a key
    while IFS=' ' read -r v1 v2 v3 v4 v5 v6 uri v8 status v10
    do
        if [ $status = "200" ]
        then
            arr["$uri"]=$((arr["$uri"] + 1))
        fi
    done < $1
    
# print the value-key pairs of the associative array and sort printed lines
    for key in "${!arr[@]}"
    do
        echo "${arr[$key]} $key"
    done | sort -rn 
    
# remove the associative array
    unset arr

else
    echo "Usage: log_parser.sh access.log"
fi
