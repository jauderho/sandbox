FROM ghcr.io/jauderho/golang:1.26.4-alpine3.23@sha256:d893e6d165d70d6da631f70850f645edeaf426b60e7394d41dac025d71157390 AS build

WORKDIR /go/src/github.com/wagoodman/dive/

ARG BUILD_VERSION
ARG DOCKER_CLI_VERSION
ARG ARCHIVE_URL=https://github.com/wagoodman/dive/archive/

ENV CGO_ENABLED=0

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	&& apk add --no-cache curl \
	&& curl -L --proto '=https' --proto-redir '=https' "${ARCHIVE_URL}${BUILD_VERSION}.tar.gz" -o /tmp/dive.tar.gz \
	&& tar xzf /tmp/dive.tar.gz --strip 1 -C /go/src/github.com/wagoodman/dive \
	&& go build -o dive-bin -v -ldflags="-s -w" \
	&& test -n "${DOCKER_CLI_VERSION}" \
	&& curl -L --proto '=https' --proto-redir '=https' "https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_CLI_VERSION}.tgz" | \
	tar -xzf - docker/docker --strip-component=1 -C /usr/local/bin

WORKDIR /config


# ----------------------------------------------------------------------------


FROM scratch

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/dive"
LABEL org.opencontainers.image.description="A tool for exploring a docker image, layer contents, and discovering ways to shrink your image size"

COPY --from=build /etc/ssl/certs /etc/ssl/certs

# static docker CLI that dive shells out to
COPY --from=build /usr/local/bin/docker /usr/local/bin/docker
COPY --from=build /go/src/github.com/wagoodman/dive/dive-bin /usr/local/bin/dive
COPY --from=build --chown=65534:65534 /config /config

ENV PATH=/usr/local/bin

HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/dive"]

