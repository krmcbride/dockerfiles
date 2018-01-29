FROM docker:17.12-git

RUN apk add --no-cache \
        coreutils \
        py-pip \
        openssl \
        tar \
        make \
        curl \
        bash

ENV DOCKER_COMPOSE_VERSION 1.18.0
RUN pip install 'docker-compose=='${DOCKER_COMPOSE_VERSION}

ENV DOCKERIZE_VERSION v0.6.0
RUN apk add --no-cache wget \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apk del wget
