# really/node-pm2-git
Docker container to fetch code from public/private repos with key where needed

[![](https://images.microbadger.com/badges/image/really/node-pm2-git.svg)](https://microbadger.com/images/really/node-pm2-git "Get your own image badge on microbadger.com") [![GitHub issues](https://img.shields.io/github/issues/reallyreally/docker-node-pm2-git.svg?style=flat-square)](https://github.com/reallyreally/docker-node-pm2-git/issues) [![GitHub license](https://img.shields.io/github/license/reallyreally/docker-node-pm2-git.svg?style=flat-square)](https://github.com/reallyreally/docker-node-pm2-git/blob/master/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/really/node-pm2-git.svg?style=flat-square)](https://github.com/reallyreally/docker-node-pm2-git/)

Launch a git hosted node project with something like:
```
docker run -d -p 8080:8080 \
  --env NPM_TOKEN=aaaaaaaa-bbbb-0000-0a0a-ffffeeee8888 \
  --env PACKAGES="make gcc g++ python" \  
  --env REPO="git@github.com:reallyreally/node-expressjs-service.git" \
  --env GIT_BRANCH="production-live" \
  --env KEYMETRICS_PUBLIC=0000aaaa1111ffff \
  --env KEYMETRICS_SECRET=0123456789abcdef \
  --env PRE_RUN="npm run build" \
  --env PM2_COMMAND="pm2.json" \
  --env PORT=8080 \
  -v $HOME/.ssh/id-rsa:/root/.ssh/id-rsa \
  cashstory/node-pm2-git
```

or in with this docker-compose.yml file:
```
version: '2'
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
      - KEYMETRICS_PUBLIC=0000aaaa1111ffff
      - KEYMETRICS_SECRET=0123456789abcdef
      - PRE_RUN=npm start build
      - PM2_COMMAND=ecosystem.json
      - PORT=8080
    volumes:
      - $HOME/.ssh/id_rsa:/root/.ssh/id_rsa
```

Environment variables
---------------------

`NPM_TOKEN` allows to use private [npmjs.com](https://www.npmjs.com) packages (optional)
`PACKAGES` allows installation of packages that might be needed for your app (optional)
`REPO_KEY` read in a file to be used as the key for your repository clone (optional)
`PRE_RUN` run command before pm2 ex: build your project (optional)
`PM2_COMMAND` the file to use with pm2 (required)
`REPO` the repository to clone (required)
`GIT_BRANCH` the branch to clone (optional)
`KEYMETRICS_PUBLIC` & `KEYMETRICS_SECRET` if you use [keymetrics.io](https://keymetrics.io) (optional)

For private repos expose your ssh-key with volume
-----------
-v $HOME/.ssh/id-rsa:/root/.ssh/id-rsa \

App Startup
-----------

In the example we call `./pm2.json` which could contain in your project the below.

```
{
  "apps": [{
    "name": "node-expressjs-service",
    "script": "./bin/www",
    "instances" : 0,
    "exec_mode" : "cluster",
    "post_update": ["npm install", "npm run build", "echo Launching..."],
    "env": {
      "production": true
    }
  }]
}
```
