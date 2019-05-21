FROM alpine:latest

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Auto mongo dump" \
  org.label-schema.description="Provides machine who never die with cron job to dump db every day" \
  org.label-schema.url="https://cashstory.com" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/BobCashStory/docker-mongo-dump" \
  org.label-schema.vendor="Cashstory, Inc." \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

ENV NPM_CONFIG_LOGLEVEL warn
ENV TZ America/Los_Angeles

# Install bash
RUN apk add --no-cache bash jq

# Install mongodb-tools
RUN apk add --no-cache mongodb mongodb-tools

# Install Python
RUN apk add --no-cache python3

# Install tzdata for cron job
RUN apk add --no-cache tzdata

# Install chaperone
RUN pip3 install chaperone 

# Install curl for slack notif 
RUN apk add --no-cache curl

# Create folder where we dump
RUN mkdir -p /dump

# Create folder for chaperone
RUN mkdir -p /etc/chaperone.d

# Copy chaperone config
COPY confs/chaperone.conf /etc/chaperone.d/chaperone.conf

# Copy scripts
COPY scripts/dump.sh /usr/local/bin/
COPY scripts/slack.sh /usr/local/bin/

# Make scripts runable
RUN chmod +x /usr/local/bin/dump.sh
RUN chmod +x /usr/local/bin/slack.sh

VOLUME /dump
WORKDIR /dump

# Clean up APT when done.
RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["/usr/bin/chaperone"]
