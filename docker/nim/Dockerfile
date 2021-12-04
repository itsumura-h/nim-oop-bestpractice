FROM nimlang/nim:1.6.0-alpine

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        openssh-client \
        openssl \
        pcre \
        bsd-compat-headers \
        sqlite

WORKDIR /app
ENV PATH $PATH:/root/.nimble/bin
