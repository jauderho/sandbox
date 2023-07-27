FROM ubuntu:23.10@sha256:23e2d6c4de2adfcbd631be39296d8eb6968e2bfbf0df86db88147f2814086bd6
#FROM python:3.11.4-slim-bullseye@sha256:1966141ab594e175852a033da2a38f0cb042b5b92896c22073f8477f96f43b06
#FROM python:3.11.4-alpine3.18@sha256:995c7fcdf9a10e0e1a4555861dac63436b456822a167f07b6599d4f105de6fa0

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
