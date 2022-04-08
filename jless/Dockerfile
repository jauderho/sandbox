#FROM alpine:3.15.4@sha256:315a3eab8ebf3bbcb931e34d13684b1e53186b8ec342c64383ce5c64890771ab AS build
FROM rust:1.59.0-alpine3.15@sha256:a8168e9102a0b338fa8b683733cc58bcc9fb2de2d4ed1198f9bff22a9ae88478 AS build
#FROM rust:1.58.0-alpine3.15

WORKDIR /usr/src/github.com/PaulJuliusMartinez/jless/
#COPY Cargo.toml Cargo.toml

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/PaulJuliusMartinez/jless/archive/
ARG GIT_URL=https://github.com/PaulJuliusMartinez/jless.git

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	&& apk add --no-cache ca-certificates git lld g++ cargo musl-dev \
	&& git clone --depth 1 ${GIT_URL} /usr/src/github.com/PaulJuliusMartinez/jless \
	&& cd /usr/src/github.com/PaulJuliusMartinez/jless \
	&& RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo build --release 

RUN target/release/jless

WORKDIR /config


# ----------------------------------------------------------------------------


#FROM scratch
FROM alpine:3.15.4@sha256:315a3eab8ebf3bbcb931e34d13684b1e53186b8ec342c64383ce5c64890771ab

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/jless"
LABEL org.opencontainers.image.description="JLess is a command-line JSON viewer designed for reading, exploring, and searching through JSON data"

COPY --from=build /etc/ssl/certs /etc/ssl/certs

COPY --from=build /usr/src/github.com/PaulJuliusMartinez/jless/target/release/jless /usr/local/bin/jless
COPY --from=build /config /config

#RUN apk update \
#	&& apk add --no-cache dumb-init

RUN /usr/local/bin/jless

USER 1000
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/jless"]
#CMD ["--help"]

