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
ENV TZ America/Los_Angeles

# Install Git
RUN apk add --no-cache \
  git \
  openssh \
  bash

# Install Python
RUN apk add --no-cache python3

# Install tzdata for cron job
RUN apk add --no-cache tzdata

# Install chaperone
RUN pip3 install chaperone 

# Install curl for slack notif 
RUN apk add --no-cache curl

# Create folder where we clone
RUN mkdir -p /usr/src

# Create folder for chaperone
RUN mkdir -p /etc/chaperone.d

# Prepare SSH 
RUN mkdir /root/.ssh && \
  touch /root/.ssh/id_rsa

# Copy SSH config
COPY confs/ssh-config /root/.ssh/config
# Set right SSH
RUN chmod 600 /root/.ssh/config 
RUN chmod 600 /root/.ssh/id_rsa

# Copy chaperone config
COPY confs/chaperone.conf /etc/chaperone.d/chaperone.conf

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
RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["/usr/bin/chaperone"]
