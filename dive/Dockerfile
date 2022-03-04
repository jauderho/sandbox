FROM golang:1.18-rc-alpine3.15@sha256:a8c33744dfc0b56098eaaea862c35a944b6df0eb92cead5bb43acf620fb14080 AS build

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
FROM alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

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

