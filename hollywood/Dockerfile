FROM ubuntu:26.10@sha256:262df65c0ec6bf8d9dcc87454f4330a05fae4b97825f45854af3b136666584c2

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
