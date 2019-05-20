#!/bin/bash

options="$MONGODUMP_OPTIONS --archive"
timestamp=`date +%Y%m%d%H%M`

if [ -z "$MONGODUMP_OPTIONS" ]; then
  echo "Required environment variable MONGODUMP_OPTIONS not found"
  exit 42
fi

if [ ! -z "$DATABASE_NAME" ]; then
  output_file="$DATABASE_NAME-$timestamp.dump"
  output_command="/dump/$output_file"
  if mongodump $options --db $DATABASE_NAME > "$output_command" ; then
    echo "Dump succeeded"
  else
    echo "Dump failed"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
      slack.sh "Dump failed" 
    fi
    exit 42
  fi
else
  output_file="$timestamp.dump"
  output_command="/dump/$output_file"
  if mongodump $options > "$output_command"; then
    echo "Dump succeeded"
  else
    echo "Dump failed"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
      slack.sh "Dump failed" 
    fi
    exit 42
  fi
fi