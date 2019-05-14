#!/bin/bash
if [ -d "/usr/src/app" ]; then
    cd /usr/src/app || exit 42
    echo "npm install"
    npm i
fi

if [ -d "/usr/src/app" ] && [ ! -z "$PRE_START" ]; then
    cd /usr/src/app || exit 42
    echo "$PRE_START"
    if $PRE_START ; then
        echo "Build succeeded"
    else
        echo "Build failed"
        if [ ! -z "$SLACK_WEBHOOK" ]; then
            slack.sh "Build failed" 
        fi
    fi
  else
    exit 42
fi