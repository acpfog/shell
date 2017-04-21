#!/bin/bash

AWS=/usr/bin/aws
SRCDIR=/home/www/project/htdocs
BUCKET=project-cdn
TMPOUT=/tmp/aws-s3-sync.out
purge_paths=""

printf %s "$(date) "
echo "Syncing $SRCDIR with s3://$BUCKET ..."

$AWS s3 sync $SRCDIR s3://$BUCKET --dryrun --delete --exclude '/.htaccess' --exclude '/*.DS_Store' --exclude '/*.php' | sed 's/Completed [0-9]* part(s) with ... file(s) remaining\r//' > $TMPOUT

if [ -f $TMPOUT ]; then

    cat $TMPOUT |
    {
    while read line; do
        stringarray=($line)
        action=${stringarray[1]}
        if [ "$action" == "upload:" ]; then
            purge_paths="$purge_paths$(echo ${stringarray[4]} | sed "s/s3:\/\/$BUCKET//") "
        fi
    done

    $AWS s3 sync $SRCDIR s3://$BUCKET --delete --exclude '/.htaccess' --exclude '/*.DS_Store' --exclude '/*.php'

    if [ ! -z "$purge_paths" ]; then
        $AWS cloudfront create-invalidation --distribution-id A1B2C3D4E5F6 --path $purge_paths
    fi

    }
    rm $TMPOUT

fi

