FROM ubuntu:23.10@sha256:ed5b80e7117fe03f4197adc76c64a86a290d31898a5d491e32f66c7eb7558fe3
#FROM python:3.12.0rc1-slim-bookworm@sha256:152284be96611303f46bacf9bba70a411557bd626c7c24fb16a888aad1b85e72
#FROM python:3.12.0rc1-alpine3.18@sha256:7bcf495f17b862d028712ec09b68962c8fe3287cb3a9c2bc87cb5de80e26d27c

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends git python3-pip && \
	python3 -m pip install --no-cache-dir --upgrade pip && \
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
LABEL org.opencontainers.image.title="jauderho/openbbterminal"
LABEL org.opencontainers.image.description="OpenBBTerminal is an awesome stock and crypto market terminal"

ENTRYPOINT ["openbb"]
#CMD ["-h"]
