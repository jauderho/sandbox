# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:26.04@sha256:2260313b31c8c011cd2eebe728008efac1b3982be73eb71348ea2648d2c0e09b

ARG DEBIAN_FRONTEND=noninteractive

# 3.5 is the current OpenSSL LTS branch and is supported until April 2030. The
# pin used to be 3.0.5, from July 2022, whose branch reaches end of life in
# September 2026. 4.0 is deliberately not used yet - it is a new major and this
# only needs a maintained TLS library, not the newest one. The version appears
# once so the download and the directory it unpacks to cannot disagree.
ARG OPENSSL_VERSION=3.5.8

RUN apt-get update && \
  # libstdc++-dev is virtual with no candidate; build-essential pulls the
  # matching libstdc++-N-dev via g++, so there is nothing to pin here
  DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends software-properties-common build-essential git wget cmake zlib1g-dev clang && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd / && \
  wget --https-only -O- "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" | tar xzf - && \
  mv "openssl-${OPENSSL_VERSION}" openssl && \
  cd openssl && \
  ./Configure --prefix=/openssl && \
  make -j$(nproc)
