FROM golang:1.23rc2-alpine@sha256:4e01b8bb65905d246d7932d6417f6e68b4ad1833940c085917ca2d6dab96933d AS build

WORKDIR /go/src/github.com/wagoodman/dive/

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/wagoodman/dive/archive/

ENV CGO_ENABLED 0

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	&& apk add --no-cache curl \
	&& curl -L "${ARCHIVE_URL}${BUILD_VERSION}.tar.gz" -o /tmp/dive.tar.gz \
	&& tar xzf /tmp/dive.tar.gz --strip 1 -C /go/src/github.com/wagoodman/dive \
	&& go build -o dive-bin -v -ldflags="-s -w" 

WORKDIR /config


# ----------------------------------------------------------------------------


#FROM scratch
FROM ghcr.io/jauderho/alpine:3.20.1@sha256:7be2d5bc23d77fca3910abe49334a98c19240510dc642a20a829b3bafa3b740d

ARG DOCKER_CLI_VERSION

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/dive"
LABEL org.opencontainers.image.description="A tool for exploring a docker image, layer contents, and discovering ways to shrink your image size"

#RUN echo $(uname -m)
#RUN echo ${DOCKER_CLI_VERSION}

RUN wget -O- https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_CLI_VERSION}.tgz | \
	tar -xzf - docker/docker --strip-component=1 && \
	mv docker /usr/local/bin

COPY --from=build /go/src/github.com/wagoodman/dive/dive-bin /usr/local/bin/dive
COPY --from=build --chown=nobody:nogroup /config /config

#USER docker
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/dive"]

