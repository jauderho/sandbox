FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/UTC

RUN \
  apt-get update -qq && \
  apt-get install -qqy tzdata mlocate hollywood && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
  dpkg-reconfigure tzdata && \
  updatedb

ENTRYPOINT [ "hollywood" ]
