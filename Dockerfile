FROM node:14.2-buster-slim

ARG SERVERLESS_VERSION=1.70.0

RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev ca-certificates make jq curl wget zip git && \
    python3 -m pip --no-cache-dir install awscli && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

RUN yarn global add serverless@${SERVERLESS_VERSION}

VOLUME ["/.config"]

WORKDIR /opt/app
