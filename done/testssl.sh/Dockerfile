# Build using git repo

FROM ghcr.io/jauderho/alpine:3.21.2@sha256:49660a4a4767aecfe40cd74f1d4b02edf1bc66867c6829beeef0aea87b5b8dd9

WORKDIR /home/testssl

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/drwetter/testssl.sh/archive/
ARG URL=https://github.com/drwetter/testssl.sh.git

RUN test -n "${BUILD_VERSION}" \
    && apk update \
    && apk add --no-cache bash procps drill git coreutils libidn curl socat openssl xxd \
	&& git clone --depth 1 --branch ${BUILD_VERSION} $URL /home/testssl \
    && addgroup testssl \
    && adduser -G testssl -g "testssl user" -s /bin/bash -D testssl \
    && ln -s /home/testssl/testssl.sh /usr/local/bin/ \
    && mkdir -m 755 -p /home/testssl/etc /home/testssl/bin

USER testssl
HEALTHCHECK NONE

ENTRYPOINT ["testssl.sh"]
CMD ["--help"]
