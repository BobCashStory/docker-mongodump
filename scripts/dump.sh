#!/bin/bash

uri="--uri $MONGO_URL"
options=${MONGODUMP_OPTIONS:-""}
timestamp=`date +%Y-%m-%d_%Hh%M`
authSource=${MONGO_AUTHSOURCE:-"admin"}
default_keep_backup="24"
keep_backup="+${KEEP_BACKUP:-$default_keep_backup}"
mode=${1:-"daily"}

echo "Mode: $mode"
echo "Keep backup: $keep_backup"

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
      echo "Backup $database succeeded"
      list_to_remove=$(ls -1t /dump | grep $mode-$database | tail -n $keep_backup)
      echo "remove backup $database older than $keep_backup files $list_to_remove"
      rm -rf $list_to_remove
      echo "Backup $database cleaned"
    else
      echo "Backup $database failed"
      if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "Backup $database failed" 
      fi
      exit 42
    fi
    echo "---------------------------------"
done

# remove dumps older than 10(keep_backup) files
# rm -rf $(ls -1t . | tail -n $keep_backup | grep $mode)
# find /dump/ -type f -name '$mode-*.gz' -mtime +$keep_backup -exec rm {} \;


