# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:26.04@sha256:2260313b31c8c011cd2eebe728008efac1b3982be73eb71348ea2648d2c0e09b

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  # libstdc++-dev is virtual with no candidate; build-essential pulls the
  # matching libstdc++-N-dev via g++, so there is nothing to pin here
  DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends software-properties-common build-essential git wget cmake zlib1g-dev clang && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd / && \
  wget --https-only -O- https://www.openssl.org/source/openssl-3.0.5.tar.gz | tar xzf - && \
  mv openssl-3.0.5 openssl && \
  cd openssl && \
  ./Configure --prefix=/openssl && \
  make -j$(nproc)
