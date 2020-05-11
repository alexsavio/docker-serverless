FROM node:10.20.1-alpine3.10

ARG SERVERLESS_VERSION=1.70.0
ARG GLIBC_VERSION=2.31-r0

RUN apk --no-cache add python3 python3-dev py-pip ca-certificates groff less bash make jq curl wget g++ zip git openssh llvm-dev libffi-dev && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/* && \
    update-ca-certificates

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    rm -f glibc-${GLIBC_VERSION}.apk

RUN apk --no-cache add openrc docker && \
    rc-update add docker boot

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

RUN yarn global add serverless@${SERVERLESS_VERSION}

VOLUME ["/.config"]

WORKDIR /opt/app
