FROM golang:alpine AS build

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	&& apk add --no-cache ca-certificates bash curl make git gcc build-base \
	&& update-ca-certificates 

RUN gcc -v
