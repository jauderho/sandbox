ARG CADDY_VERSION=2.11.4
ARG DOCKER_PROXY_VERSION=v2.13.1
ARG CLOUDFLARE_DNS_VERSION=v0.2.4

FROM caddy:2.11.4-builder-alpine@sha256:fc72c8a37cb774f155094d7f08e48b67876477e0d11ca96f58d9cf5b0cff42c8 AS builder

ARG CADDY_VERSION
ARG DOCKER_PROXY_VERSION
ARG CLOUDFLARE_DNS_VERSION

RUN apk add -U --no-cache ca-certificates && xcaddy build "v${CADDY_VERSION}" \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@${DOCKER_PROXY_VERSION} \
    --with github.com/caddy-dns/cloudflare@${CLOUDFLARE_DNS_VERSION}

#FROM caddy:${CADDY_VERSION}-alpine
FROM scratch

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/caddy-docker-proxy"
LABEL org.opencontainers.image.description="Caddy with the docker-proxy and Cloudflare DNS modules built in"

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

WORKDIR /

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

HEALTHCHECK NONE

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
#CMD ["caddy", "docker-proxy"]
