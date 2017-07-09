# Note: this file is generated, do not edit directly

FROM alpine:3.4
LABEL maintainer="krmcbride.io@gmail.com"

RUN apk add --no-cache \
      tzdata \
    && cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
    && echo "America/Los_Angeles" > /etc/timezone \
    && date \
    && apk del tzdata \
    && apk add --no-cache \
      bash \
      ca-certificates \
      curl \
    && mkdir -p /usr/src/app

# bash
COPY common/bash-it/ /usr/local/bash-it/
COPY common/dotfiles/.bashrc /root/

WORKDIR /root
SHELL ["/bin/bash", "-c"]
CMD ["/bin/bash"]
