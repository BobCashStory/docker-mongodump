#!/bin/bash

CHANNEL=${SLACK_CHANNEL:="#general"} 
USERNAME=${SLACK_NAME:="MyBot"} 
EMOJI=${SLACK_EMOJI:=":ghost:"} 
MSG=${1:="Hello World"} 

PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$MSG\", \"icon_emoji\": \"$EMOJI\"}"

curl -X POST --data-urlencode "$PAYLOAD" "$SLACK_WEBHOOK"