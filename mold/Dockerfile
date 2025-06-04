# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:25.10@sha256:dd397d3b5e4896054db111cb5145c0c08a6e7a669537e750e79e0385f2d69207

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends software-properties-common build-essential git wget cmake libstdc++-11-dev zlib1g-dev clang-14 && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd / && \
  wget -O- https://www.openssl.org/source/openssl-3.0.5.tar.gz | tar xzf - && \
  mv openssl-3.0.5 openssl && \
  cd openssl && \
  ./Configure --prefix=/openssl && \
  make -j$(nproc)
