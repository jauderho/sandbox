FROM ubuntu:25.04@sha256:79efa276fdefa2ee3911db29b0608f8c0561c347ec3f4d4139980d43b168d991
#FROM python:3.14.0a4-slim-bookworm@sha256:b4f90f11d2b67df64bbb113b2df219713327527571afb005e07b8546df1d2187
#FROM python:3.14.0b1-alpine3.21@sha256:a8d1bd3114425245dd43284155f4b5f385e7caba94f3576c1bfc23c0773ada48

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
