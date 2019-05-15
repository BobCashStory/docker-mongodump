# BobCashStory/node-git
Docker container to fetch code from public/private repos with key where needed

[![](https://images.microbadger.com/badges/image/cashstory/docker-node-pm2-git.svg)](https://microbadger.com/images/cashstory/docker-node-pm2-git "Get your own image badge on microbadger.com")
[![GitHub issues](https://img.shields.io/github/issues/BobCashStory/docker-node-pm2-git.svg?style=flat-square)](https://github.com/BobCashStory/docker-node-pm2-git/issues) [![GitHub license](https://img.shields.io/github/license/reallyreally/docker-node-pm2-git.svg?style=flat-square)](https://github.com/BobCashStory/docker-node-pm2-git/blob/master/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/cashstory/docker-node-pm2-git.svg?style=flat-square)](https://github.com/BobCashStory/docker-node-pm2-git/)

Launch a git hosted node project with something like:
```
docker run -d -p 8080:8080 \
  --env NPM_TOKEN=aaaaaaaa-bbbb-0000-0a0a-ffffeeee8888 \
  --env PACKAGES="make gcc g++ python" \  
  --env REPO="git@github.com:reallyreally/node-expressjs-service.git" \
  --env GIT_BRANCH="production-live" \
  --env SLACK_WEBHOOK="https://slack_url" \
  --env PRE_RUN="npm run build" \
  --env NODE_ENTRYPOINT="npm run dist" \
  --env PORT=8080 \
  -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa \
  cashstory/node-pm2-git
```

or in with this docker-compose.yml file:
```
version: '3'
services:
  darkknight:
    image: cashstory/docker-node-pm2-git:latest
    container_name: darkknight
    restart: always
    ports:
      - 8001:8080
    environment:
      - NPM_TOKEN=aaaaaaaa-bbbb-0000-0a0a-ffffeeee8888
      - PACKAGES="make gcc g++ python"
      - REPO=git@github.com:reallyreally/node-expressjs-service.git
      - GIT_BRANCH=production-live
      - PRE_RUN=npm start build
      - NODE_ENTRYPOINT=npm run dist
      - PORT=8080
    volumes:
      - $HOME/.ssh/id_rsa:/root/.ssh/id_rsa
```

Environment variables
---------------------

`NPM_TOKEN` allows to use private [npmjs.com](https://www.npmjs.com) packages (optional)
`PACKAGES` allows installation of packages that might be needed for your app (optional)
`REPO_KEY` read in a file to be used as the key for your repository clone (optional)
`PRE_RUN` run command before NODE_ENTRYPOINT ex: fetch dependency (optional)
`NODE_ENTRYPOINT` the command to run your code
`REPO` the repository to clone (required)
`GIT_BRANCH` the branch to clone (optional)
`SLACK_WEBHOOK` slack webhook to receive status notifs (optional)
`SLACK_NAME` slack name to receive status notifs (optional)
`SLACK_CHANNEL` slack channel to receive status notifs (optional)
`SLACK_EMOJI` slack EMOJI to receive status notifs (optional)

For private repos expose your ssh-key with volume
-----------
-v YOUR_KEY_PATH:/root/.ssh/id_rsa \

App Startup
-----------


Utility
-------

get into container `docker exec -i -t container_name bash`

build new version of container `docker build . -t cashstory/node-git:latest`
push new version onf container `docker push cashstory/node-git:latest`