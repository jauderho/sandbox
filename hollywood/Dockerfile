FROM ubuntu:25.10@sha256:fcdea13661343a0113773e1f3c481336462222a08993a9a83eae58268746d139

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
