#!/bin/bash

if [ -d "/usr/src/app" ] && [ ! -z "$NODE_ENTRYPOINT" ]; then
    cd /usr/src/app || exit 42
    slack.sh "Starting NodeJS application !"
    node $NODE_ENTRYPOINT
    slack.sh "Stoping NodeJS application !"
else
    echo "There is no NodeJS application installed or $NODE_ENTRYPOINT exit"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
        slack.sh "There is no NodeJS application installed or $NODE_ENTRYPOINT exit"
    fi
    exit 42
fi
