FROM node:8.16-alpine

ARG CLOUD_SDK_VERSION=253.0.0
ARG SHA256SUM=df3834e538025b257b7cc5d6e7518ca16f05e99aa82671dda19045e688b5268a
ARG SERVERLESS_VERSION=1.46.1

RUN apk --no-cache add python python3 python3-dev py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh && \
    apk --no-cache add libffi libffi-dev openssl-dev && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/* && \
    update-ca-certificates

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    rm -f glibc-2.25-r0.apk

RUN mkdir -p /tmp/yarn && \
  mkdir -p /opt/yarn/dist && \
  cd /tmp/yarn && \
  wget -q https://yarnpkg.com/latest.tar.gz && \
  tar zvxf latest.tar.gz && \
  find /tmp/yarn -maxdepth 2 -mindepth 2 -exec mv {} /opt/yarn/dist/ \; && \
  rm -rf /tmp/yarn

RUN ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarn && \
    ln -sf /opt/yarn/dist/bin/yarn /usr/local/bin/yarnpkg && \
    yarn --version

ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    echo "${SHA256SUM}  google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" > google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 && \
    sha256sum -c google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN yarn global add serverless@${SERVERLESS_VERSION}

VOLUME ["/.config"]

WORKDIR /opt/app
