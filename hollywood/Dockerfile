FROM ubuntu:25.10@sha256:c2f4a9afab35d0c71fa2ed919c60d4b2b48ef5fd4f3dc69dfb9a12350a6dc66c

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
