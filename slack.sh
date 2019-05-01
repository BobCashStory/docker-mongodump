#!/bin/bash

CHANNEL="#general"
USERNAME="MyBot"
EMOJI=":ghost:"
MSG=$1

PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$MSG\", \"icon_emoji\": \"$EMOJI\"}"
HOOK=https://hooks.slack.com/services/T00000000/XXXXYYYZ/XXXXXXXX

curl -X POST --data-urlencode "$PAYLOAD" "$HOOK"