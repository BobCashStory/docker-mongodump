#!/usr/bin/env sh
set -x

if [ -z "$NODE_ENV" ]; then
  NODE_ENV=production
  export NODE_ENV
fi

if [ ! -z "$PACKAGES" ]; then
  apk add --no-cache $PACKAGES
fi

if [ ! -z "$NPM_TOKEN" ]; then
  echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > /root/.npmrc
fi

if [ ! -d "/usr/src/app/.git" ]; then

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
  git clone --depth=1 $GITBRANCHCMD $REPO /usr/src/app
  if [ -d "/usr/src/app/.git" ]; then
    cd /usr/src/app || exit
    ls -al
  else
    echo "Failed to fetch repository"
    if [ ! -z "$SLACK_WEBHOOK" ]; then
      sh slack.sh "Failed to fetch repository $REPO"
    fi
    exit 42
  fi
fi

sh prepare.sh

if [ -d "/usr/src/app" ]; then
  /usr/bin/supervisord -n -c /etc/supervisord.conf
fi
