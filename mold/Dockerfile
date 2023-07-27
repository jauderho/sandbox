# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:23.10@sha256:23e2d6c4de2adfcbd631be39296d8eb6968e2bfbf0df86db88147f2814086bd6

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
