#!/usr/bin/env sh
set -x

local options="$MONGODUMP_OPTIONS --archive"
local timestamp="\`date +%Y%m%d%H%M\`"

if [ -z "$MONGODUMP_OPTIONS" ]; then
  echo "Required environment variable MONGODUMP_OPTIONS not found"
  exit 42
fi

if [ ! -z "$DATABASE_NAME" ]; then
  local output_file="$DATABASE_NAME-$timestamp.dump"
  local output_command="/dump/$output_file"
  if mongodump $options --db $DATABASE_NAME > $output_command ; then
    echo "Dump succeeded"
  else
    echo "Dump failed"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "Dump failed" 
    fi
    exit 42
  fi
else
  local output_file="$timestamp.dump"
  local output_command="/dump/$output_file"
  if mongodump $options > $output_command; then
    echo "Dump succeeded"
  else
    echo "Dump failed"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "Dump failed" 
    fi
    exit 42
  fi
fi