FROM ubuntu:26.04@sha256:cc925e589b7543b910fea57a240468940003fbfc0515245a495dd0ad8fe7cef1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# EXPOSE
# STOPSIGNAL
HEALTHCHECK NONE
# USER
RUN \
  apt-get update -qq && \
  apt-get install -qqy tzdata mlocate hollywood && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
  dpkg-reconfigure tzdata && \
  updatedb

ENTRYPOINT [ "hollywood" ]
