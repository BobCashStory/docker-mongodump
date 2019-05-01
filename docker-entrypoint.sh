#!/usr/bin/env sh
set -x

if [ -z "$NODE_ENV" ]; then
  NODE_ENV=production
  export NODE_ENV
fi

if [ ! -d "/usr/src/app/.git" ]; then

  if [ ! -z "$PACKAGES" ]; then
    apk add --no-cache $PACKAGES
  fi

  if [ ! -z "$NPM_TOKEN" ]; then
    echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > /root/.npmrc
  fi

  if [ ! -z "$GIT_BRANCH" ]; then
    GITBRANCHCMD="-b ${GIT_BRANCH}"
  else
    GITBRANCHCMD=""
  fi

  if [ ! -s "/root/.ssh/id_rsa" ]; then
    echo "No private key provided - removing configuration"
    rm -f /root/.ssh/id_rsa /root/.ssh/config
  fi  

  echo "Cloning ${REPO}"
  git clone $GITBRANCHCMD $REPO /usr/src/app
  if [ -d "/usr/src/app/.git" ]; then
    cd /usr/src/app || exit
    ls -al
  else
    echo "Failed to fetch repository"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
      sh ./slack.sh "Failed to fetch repository $REPO"
    fi
    exit 42
  fi
fi

if [ -d "/usr/src/app" ] && [ ! -z "$PRE_RUN" ]; then
  cd /usr/src/app || exit 42
  echo "$PRE_RUN"
  $PRE_RUN
fi

if [ -d "/usr/src/app" ] && [ ! -z "$NODE_COMMAND" ]; then
  cd /usr/src/app || exit 42
  $NODE_COMMAND
else
  echo "There is no NodeJS application installed or $NODE_COMMAND exit"
  if [ ! -z "$SLACK_WEBHOOK" ]; then
    sh ./slack.sh "There is no NodeJS application installed or $NODE_COMMAND exit"
  fi
  exit 42
fi

