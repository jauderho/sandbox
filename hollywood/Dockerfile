FROM ubuntu:23.10@sha256:c1c5a248f628c287d3472d86b0e5c9ca2ef0280475e50b46ad371f566b72e680

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
