#!/bin/bash

# Set variables with paths
AWS=/usr/bin/aws
SRCDIR=/home/www/project/htdocs
BUCKET=project-cdn
TMPOUT=/tmp/aws-s3-sync.out
# set a variable for the result
purge_paths=""

# Print current date and time
printf %s "$(date) "
echo "Syncing $SRCDIR with s3://$BUCKET ..."

# Dry run of aws sync, get a log of actions, remove progress lines from the log and write it to a tmp file
# I tryed to move exclude options in a variable, but it doesn't work in this way
$AWS s3 sync $SRCDIR s3://$BUCKET --dryrun --delete --exclude '/.htaccess' --exclude '/*.DS_Store' --exclude '/*.php' | sed 's/Completed [0-9]* part(s) with ... file(s) remaining\r//' > $TMPOUT

# Parse the tmp file with aws sync log
if [ -f $TMPOUT ]; then

    cat $TMPOUT |
    {
    while read line; do
        stringarray=($line)
        action=${stringarray[1]}
        if [ "$action" == "upload:" ]; then
# Put a filename to the result if the file is uploaded
            purge_paths="$purge_paths$(echo ${stringarray[4]} | sed "s/s3:\/\/$BUCKET//") "
        fi
    done
# Run a synchronization
    $AWS s3 sync $SRCDIR s3://$BUCKET --delete --exclude '/.htaccess' --exclude '/*.DS_Store' --exclude '/*.php'
# Purge updated objects from edge servers 
    if [ ! -z "$purge_paths" ]; then
        $AWS cloudfront create-invalidation --distribution-id A1B2C3D4E5F6 --path $purge_paths
    fi

    }
# Delete the tmp file with aws sync log
    rm $TMPOUT

fi

