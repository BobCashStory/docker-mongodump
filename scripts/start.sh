#!/bin/bash

if [ -z "$NODE_ENV" ]; then
  NODE_ENV="production"
  export NODE_ENV
fi

if [ -d "/usr/src/app" ] && [ ! -z "$NODE_ENTRYPOINT" ]; then
    cd /usr/src/app || exit 42
    slack.sh "Starting NodeJS application in $NODE_ENV !"
    nohup node $NODE_ENTRYPOINT &
else
    echo "There is no NodeJS application installed or $NODE_ENTRYPOINT exit"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "There is no NodeJS application installed or $NODE_ENTRYPOINT exit"
    fi
    exit 42
fi
