FROM ubuntu:26.10@sha256:ee126c2fa0249079a7e24ae3a3d29b04783ef93ab33c868751c9a1289d3fffff

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
