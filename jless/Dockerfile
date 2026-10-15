#FROM ghcr.io/jauderho/alpine:3.21.0@sha256:f1c32703dfc24d994cb29a14dba612df8cd56ef5c4df8e443803d11cacadd150 AS build
FROM rust:1.78.0-alpine3.18@sha256:34f1c35f62e192f39cd0c809982bf90c354f7e5746682a2f4c9e4c43bd516dbc AS build
#FROM rust:1.58.0-alpine3.15

WORKDIR /usr/src/github.com/PaulJuliusMartinez/jless/
#COPY Cargo.toml Cargo.toml

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/PaulJuliusMartinez/jless/archive/
ARG GIT_URL=https://github.com/PaulJuliusMartinez/jless.git

RUN test -n "${BUILD_VERSION}" \
	&& apk update \
	# xcb 0.8.2's build script shells out to python3. The X libs it links against
	# ship no .a archives on alpine, so the musl target's default static link is
	# turned off and jless is linked dynamically instead.
	&& apk add --no-cache ca-certificates git lld g++ cargo musl-dev python3 libxcb-dev libxau-dev libxdmcp-dev \
	&& git clone --depth 1 ${GIT_URL} /usr/src/github.com/PaulJuliusMartinez/jless \
	&& cd /usr/src/github.com/PaulJuliusMartinez/jless \
	&& RUSTFLAGS="-C link-arg=-fuse-ld=lld -C target-feature=-crt-static" cargo build --release

# smoke test - a bare invocation reads stdin, hits EOF and exits 1
RUN target/release/jless --version

# scratch has no loader or package manager, so gather jless plus every shared
# object it needs (musl loader, libxcb, libXau, libXdmcp, libgcc_s) into a
# rootfs. ldd resolves the right paths on both amd64 and arm64.
RUN mkdir -p /rootfs/usr/local/bin \
	&& cp target/release/jless /rootfs/usr/local/bin/jless \
	&& ldd target/release/jless | awk '$3 ~ /^\// { print $3 } $1 ~ /^\// { print $1 }' | sort -u \
	| while read -r lib; do cp --parents -L "$lib" /rootfs; done

WORKDIR /config


# ----------------------------------------------------------------------------


FROM scratch

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/jless"
LABEL org.opencontainers.image.description="JLess is a command-line JSON viewer designed for reading, exploring, and searching through JSON data"

COPY --from=build /etc/ssl/certs /etc/ssl/certs

COPY --from=build /rootfs/ /
COPY --from=build /config /config

USER 1000
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/jless"]
#CMD ["--help"]

