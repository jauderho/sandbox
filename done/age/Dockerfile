FROM golang:1.22rc2-alpine3.19@sha256:4532dcab2919d1f74b57449ef73b53d78f2c1ff29100062c8328426ea0266b25 AS build

WORKDIR /go/src/github.com/FiloSottile/age/

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/FiloSottile/age/archive/

ENV CGO_ENABLED 0

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	&& apk add --no-cache ca-certificates curl gcc musl-dev \
	&& update-ca-certificates \
	&& curl -L "${ARCHIVE_URL}${BUILD_VERSION}.tar.gz" -o /tmp/age.tar.gz \
	&& tar xzf /tmp/age.tar.gz --strip 1 -C /go/src/github.com/FiloSottile/age \
	&& go build -o . -v -trimpath -ldflags="-s -w -X main.Version=${BUILD_VERSION}" filippo.io/age/cmd/... 

WORKDIR /config


# ----------------------------------------------------------------------------


FROM scratch
#FROM alpine:3.14

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/age"
LABEL org.opencontainers.image.description="age is a simple, modern and secure file encryption tool, format, and Go library"

COPY --from=build /etc/ssl/certs /etc/ssl/certs

COPY --from=build /go/src/github.com/FiloSottile/age/age /usr/local/bin/age
COPY --from=build /go/src/github.com/FiloSottile/age/age-keygen /usr/local/bin/age-keygen
COPY --from=build /config /config

HEALTHCHECK NONE

CMD ["/usr/local/bin/age"]
