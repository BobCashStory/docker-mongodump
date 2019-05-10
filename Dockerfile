FROM node:10-alpine

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Node.JS supervised and git" \
  org.label-schema.description="Provides node with working git. Supports starting apps from node or others script ." \
  org.label-schema.url="https://cashstory.com" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/BobCashStory/docker-node-pm2-git" \
  org.label-schema.vendor="Cashstory, Inc." \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

ENV NPM_CONFIG_LOGLEVEL warn

# Install Git
RUN apk add --no-cache \
  git \
  openssh \
  openssl \
  bash

# Install Python
RUN apk add --no-cache python 

# Install Supervisor
RUN apk add --no-cache supervisor

# Install Cron
RUN apk add --no-cache dcron

# Install mininum packages
RUN apk add --no-cache \
  curl make supervisor gcc g++ python linux-headers binutils-gold gnupg libstdc++

# Create folder where we clone
RUN mkdir -p /usr/src

# Prepare Cron
RUN mkdir -p /var/log/cron && \
  mkdir -m 0644 -p /var/spool/cron/crontabs && \
  touch /var/log/cron/cron.log && \
  mkdir -m 0644 -p /etc/cron.d

# Prepare SSH 
RUN mkdir /root/.ssh && \
  touch /root/.ssh/id_rsa

# Copy SSH config
COPY confs/ssh-config /root/.ssh/config
# Set right SSH
RUN chmod 600 /root/.ssh/config 
RUN chmod 600 /root/.ssh/id_rsa

# Copy supervisor config
COPY confs/supervisord.conf /etc/supervisord.conf

# Copy cron config
COPY confs/crontab /etc/cron.d/hello-cron

# Copy scripts
COPY scripts/entrypoint.sh /usr/local/bin/
COPY scripts/prepare.sh /usr/local/bin/
COPY scripts/gitpull.sh /usr/local/bin/
COPY scripts/start.sh /usr/local/bin/
COPY scripts/slack.sh /usr/local/bin/

# Make scripts runable
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/prepare.sh
RUN chmod +x /usr/local/bin/gitpull.sh
RUN chmod +x /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/slack.sh

RUN mkdir -p /app
VOLUME /app
WORKDIR /app

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["entrypoint.sh"]
