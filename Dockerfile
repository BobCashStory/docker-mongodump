FROM keymetrics/pm2:latest

ENV NPM_CONFIG_LOGLEVEL warn

RUN apk add --update --no-cache git ca-certificates && \
  update-ca-certificates && \
  apk --update add --no-cache openssl openssh bash && \
  rm -rf /tmp/* /var/cache/apk/* && \
  mkdir -p /usr/src && \
  mkdir /root/.ssh && \
  touch /root/.ssh/repo-key && \
  echo "IdentityFile /root/.ssh/repo-key" > /root/.ssh/config && \
  chmod 600 /root/.ssh/config && \
  chmod 600 /root/.ssh/repo-key

RUN pm2 install pm2-auto-pull

RUN pm2 set pm2-auto-pull:interval 60000

COPY known_hosts /root/.ssh/known_hosts
COPY docker-entrypoint.sh /usr/local/bin/

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

COPY known_hosts /root/.ssh/known_hosts
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
