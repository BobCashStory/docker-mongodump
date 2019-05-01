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
    mkdir -pv /usr/src/app/.git/hooks
    printf "#!/usr/bin/env sh\nif [ -f \"/usr/src/app/yarn.lock\" ]; then\n  cd /usr/src/app || exit\n  rm -Rf ./node_modules\n  yarn install\nelif [ -f \"/usr/src/app/package.json\" ]; then\n  cd /usr/src/app || exit\n  rm -Rf ./node_modules\n  npm install\nfi" > /usr/src/app/.git/hooks/post-merge
    chmod 555 /usr/src/app/.git/hooks/post-merge
    /usr/src/app/.git/hooks/post-merge
    ls -al
  else
    echo "Failed to fetch repository"
  fi
fi

if [ -d "/usr/src/app" ] && [ ! -z "$PRE_RUN" ]; then
  cd /usr/src/app || exit
  echo "$PRE_RUN"
  $PRE_RUN
fi

if [ -d "/usr/src/app" ] && [ ! -z "$NODE_COMMAND" ]; then
  cd /usr/src/app || exit
  $NODE_COMMAND
else
  echo "There is no NodeJS application installed or $NODE_COMMAND exit"
fi

