# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:26.10@sha256:6a2abc30a3e00fa62e756ddff3698def66314e29fab5fc851d7f298ffda17449

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
