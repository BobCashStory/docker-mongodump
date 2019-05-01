FROM node:10-alpine

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Node.JS with PM2 and git" \
  org.label-schema.description="Provides node with working git. Supports starting apps from node or others script ." \
  org.label-schema.url="https://cashstory.com" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://BobCashStory/reallyreally/docker-node-pm2-git" \
  org.label-schema.vendor="Cashstory, Inc." \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

ENV NPM_CONFIG_LOGLEVEL warn

RUN apk add --update --no-cache git ca-certificates && \
  update-ca-certificates && \
  apk add --update --no-cache openssl openssh bash && \
  apk add --update --no-cache curl nano make gcc g++ python linux-headers binutils-gold gnupg libstdc++ && \
  rm -rf /tmp/* /var/cache/apk/* && \
  mkdir -p /usr/src && \
  mkdir /root/.ssh && \
  touch /root/.ssh/id_rsa && \
  echo "IdentityFile /root/.ssh/id_rsa" > /root/.ssh/config && \
  chmod 600 /root/.ssh/config && \
  chmod 600 /root/.ssh/id_rsa

COPY known_hosts /root/.ssh/known_hosts
COPY docker-entrypoint.sh /usr/local/bin/

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

COPY known_hosts /root/.ssh/known_hosts
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
