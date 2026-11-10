ARG CADDY_VERSION=2.11.4
ARG DOCKER_PROXY_VERSION=v2.13.1
ARG CLOUDFLARE_DNS_VERSION=v0.2.4

FROM caddy:2.11.9-builder-alpine@sha256:d26fbc8a56ed8c3c1534f5573162d148ad3ed41732665da8526eb181fac0b728 AS builder

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
