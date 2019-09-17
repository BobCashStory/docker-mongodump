# BobCashStory/docker-mongodump
Docker container periodicaly mongodump a mongodb

Launch a cron job who do mongodump of each db :
```
docker run -d -p 8080:8080 \
  --env MONGO_URL: mongodb://root:blablabla@cs-mongodb:27017/ \
  cashstory/mongodump
```

or in with this docker-compose.yml file:
```
version: '3'
services:
  mongo_dump:
    image: cashstory/mongodump:latest
    container_name: mongo_dump
    restart: always
    environment:
      - MONGO_URL=mongodb://root:blablabla@cs-mongodb:27017/
    volumes:
      - mongo_db_dump:/dump
```

Environment variables
---------------------

`MONGO_URL` uri for dump command (mendatory)
`MONGODUMP_OPTIONS` add all option to dump command (optional)
`MONGO_AUTHSOURCE` source for auth db 'admin' by default (optional)
`KEEP_BACKUP` number of backup we keep for hourly, daily and monthly backup before remove dump from volume '24' by default (optional)
`SLACK_WEBHOOK` slack webhook to receive status notifs (optional)
`SLACK_NAME` slack name to receive status notifs (optional)
`SLACK_CHANNEL` slack channel to receive status notifs (optional)
`SLACK_EMOJI` slack EMOJI to receive status notifs (optional)

Utility
-------

get into container `docker exec -i -t container_name bash`

build new version of container `docker build . -t cashstory/node-git:latest`
push new version onf container `docker push cashstory/node-git:latest`