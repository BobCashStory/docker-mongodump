#!/bin/bash

if [ -d "/usr/src/app" ]; then
    cd /usr/src/app || exit 42
    echo "npm install"
    npm i
fi
