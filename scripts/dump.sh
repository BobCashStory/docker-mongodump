#!/bin/bash

uri="--uri $MONGO_URL"
options="${MONGODUMP_OPTIONS:- }"
timestamp=`date +%Y-%m-%d_%Hh%M`
authSource=${MONGO_AUTHSOURCE:-admin}
keep_backup=${KEEP_BACKUP:-24}
mode="${1:-daily}"

echo "Mode: $mode"
if [ -z "$MONGO_URL" ]; then
  echo "Required environment variable MONGO_URL not found"
  exit 42
fi


DATABASES=`mongo $MONGO_URL?authSource=$authSource --quiet --eval "printjson(db.adminCommand('listDatabases'))" | jq -r '.databases[].name'`

echo "$DATABASES"
for database in ${DATABASES[@]} 
do
    echo "---------------------------------"
    echo "Start to dump" ${database}
    output_file="$mode-$database-$timestamp.gz"
    output_command="/dump/$output_file"
    if mongodump $uri$database?authSource=$authSource $options --gzip --archive="$output_command" ; then
      echo "Dump $database succeeded"
    else
      echo "Dump $database failed"
      if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "Dump $database failed" 
      fi
      exit 42
    fi
    echo "---------------------------------"
done

# remove dumps older than 10(keep_backup) files
rm -rf $(ls -1t . | tail -n +$keep_backup | grep $mode)
# find /dump/ -type f -name '$mode-*.gz' -mtime +$keep_backup -exec rm {} \;


