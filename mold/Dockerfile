# This dockerfile creates a reproducible build environment for mold.
#
# $ docker build -t rui314/mold-builder:v1-$(uname -m) .
# $ docker push rui314/mold-builder:v1-$(uname -m)

FROM ubuntu:22.10@sha256:4f9ec2c0aa321966bfe625bc485aa1d6e96549679cfdf98bb404dfcb8e141a7f

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
