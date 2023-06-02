## Dockerfile for building a docker imapsync image

# $Id: Dockerfile,v 1.38 2021/11/29 10:20:56 gilles Exp gilles $

FROM ubuntu:23.10@sha256:2cde79b4627d38d1448fc264f93e465f18b653bc9a62ee8ec85d99d4e8f39d4c

ARG BUILD_VERSION

RUN set -xe && \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  libauthen-ntlm-perl \
  libcgi-pm-perl \
  libcrypt-openssl-rsa-perl \
  libdata-uniqid-perl \
  libdigest-hmac-perl \
  libdist-checkconflicts-perl \
  libencode-imaputf7-perl \
  libfile-copy-recursive-perl \
  libfile-tail-perl \
  libio-compress-perl \
  libio-socket-ssl-perl \
  libio-socket-inet6-perl \
  libio-tee-perl \
  libhtml-parser-perl \
  libjson-webtoken-perl \
  libmail-imapclient-perl \
  libparse-recdescent-perl \
  libmodule-scandeps-perl \
  libpar-packer-perl \
  libreadonly-perl \
  libregexp-common-perl \
  libsys-meminfo-perl \
  libterm-readkey-perl \
  libunicode-string-perl \
  liburi-perl  \
  libwww-perl \
  wget \
  make \
  time \
  cpanminus \
  openssl \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && cd /usr/bin/ \
  && pwd \
  && wget -N https://imapsync.lamiral.info/imapsync \
        https://imapsync.lamiral.info/prerequisites_imapsync \
        https://raw.githubusercontent.com/google/gmail-oauth2-tools/master/python/oauth2.py \
  && chmod +x imapsync oauth2.py \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/imapsync"
LABEL org.opencontainers.image.description="Email IMAP tool for syncing, copying, migrating and archiving email mailboxes between servers"

WORKDIR /var/tmp/

ENV HOME /var/tmp/
USER nobody:nogroup
HEALTHCHECK NONE
STOPSIGNAL SIGINT

#CMD ["/usr/bin/imapsync"]

ENTRYPOINT ["/usr/bin/imapsync"]
CMD ["--help"]

# End of imapsync Dockerfile 
