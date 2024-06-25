ARG CADDY_VERSION=2.8.1

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN apk add -U --no-cache ca-certificates && xcaddy build \
    --with github.com/jauderho/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

#FROM caddy:${CADDY_VERSION}-alpine
FROM scratch

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
#CMD ["caddy", "docker-proxy"]

