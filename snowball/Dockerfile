FROM ubuntu:26.10@sha256:c4ca31b6e93261c5dd773826f789738a49e414ca04fc094b1ccd0f91e07329a2

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://snowball-client.s3.us-west-2.amazonaws.com/latest/snowball-client-linux.tar.gz

RUN test -n "${BUILD_VERSION}" \
	&& apt-get update \
	&& apt-get dist-upgrade -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl \
	&& curl -L --proto '=https' --proto-redir '=https' "${ARCHIVE_URL}" -o /tmp/snowball.tar.gz \
	&& tar xzf /tmp/snowball.tar.gz --strip 1 -C /usr/local \
	&& rm -rf /tmp/snowball.tar.gz \
	&& apt-get purge -y curl \
	&& apt-get autoremove -y --purge \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/snowball"
LABEL org.opencontainers.image.description="The Snowball Edge Client is used to manage a Snowball device"

#RUN /usr/local/bin/snowball

CMD ["/usr/local/bin/snowball"]

