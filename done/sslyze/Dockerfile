#FROM ubuntu:21.04
#FROM ubuntu:24.10@sha256:c62f1babc85f8756f395e6aabda682acd7c58a1b0c3bea250713cd0184a93efa
FROM ubuntu:24.10@sha256:c62f1babc85f8756f395e6aabda682acd7c58a1b0c3bea250713cd0184a93efa
#FROM python:3.12.0-slim-bookworm@sha256:43a49c9cc2e614468e3d1a903aabe17a97a4c788c76cf5337b5cdc3535b07d4f
#FROM python:3.12.0-alpine3.18@sha256:ae35274f417fc81ba6ee1fc84206e8517f28117566ee6a04a64f004c1409bdac

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN apt-get update && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends python3-pip && \
	pip3 install --no-cache-dir -r requirements.txt && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

#	apt-get purge -y python3-dev && \
#RUN pip install sslyze==${BUILD_VERSION}
#RUN pip3 install --no-cache-dir -r requirements.txt

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/sslyze"
LABEL org.opencontainers.image.description="SSLyze is a fast and powerful SSL/TLS scanning library"

HEALTHCHECK NONE

ENTRYPOINT ["sslyze"]
CMD ["-h"]
