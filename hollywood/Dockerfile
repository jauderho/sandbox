FROM ubuntu:26.10@sha256:1c2a84ae3f2a24aeb97cded5b41f0211b441662f1a188cbd2e139e7625f6f1d6

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN \
  apt-get update -qq && \
  apt-get install -qqy tzdata plocate hollywood && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
  dpkg-reconfigure tzdata && \
  updatedb

ENTRYPOINT [ "hollywood" ]
