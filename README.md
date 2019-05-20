# BobCashStory/docker-mongodump
Docker container periodicaly mongodump a mongodb

Launch a cron job who do mongodump hosted node project with something like:
```
docker run -d -p 8080:8080 \
  --env MONGODUMP_OPTIONS: --host cs-mongodb:27017 -u root -p blablabla \
  --env CRON_ENTRY: 
  -v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa \
  cashstory/node-pm2-git
```

or in with this docker-compose.yml file:
```
version: '3'
services:
  mongo_dump:
    image: cashstory/docker-mongo-dump:latest
    container_name: mongo_dump
    restart: always
    environment:
      MONGODUMP_OPTIONS: --host cs-mongodb:27017 -u root -p blablabla
    volumes:
      - mongo_db_dump:/dump
```

Environment variables
---------------------

`MONGODUMP_OPTIONS` add all option to dump command (mendatory)
`DATABASE_NAME` select the database you wanna dump, if no value it dump all (optional)
`CRON_ENTRY` cron recurence for dump (optional)
`SLACK_WEBHOOK` slack webhook to receive status notifs (optional)
`SLACK_NAME` slack name to receive status notifs (optional)
`SLACK_CHANNEL` slack channel to receive status notifs (optional)
`SLACK_EMOJI` slack EMOJI to receive status notifs (optional)

Utility
-------

get into container `docker exec -i -t container_name bash`

build new version of container `docker build . -t cashstory/node-git:latest`
push new version onf container `docker push cashstory/node-git:latest`