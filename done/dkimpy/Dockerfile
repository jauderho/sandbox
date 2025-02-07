FROM ghcr.io/jauderho/alpine:3.21.2@sha256:e7f3117165afa2d56675922cdb717f94b22f724b385e07bfa096ede4ee58c323
#FROM python:3.12.0-slim-bookworm@sha256:43a49c9cc2e614468e3d1a903aabe17a97a4c788c76cf5337b5cdc3535b07d4f
#FROM python:3.12.0-alpine3.18@sha256:ae35274f417fc81ba6ee1fc84206e8517f28117566ee6a04a64f004c1409bdac

ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN \
	apk update && \
	apk upgrade -a && \
	build_pkgs="python3-dev" && \
  runtime_pkgs="ca-certificates openssl python3 py3-pip" && \
  apk --no-cache add --virtual build-dependencies ${build_pkgs} && \
  apk --no-cache add ${runtime_pkgs} && \
	python3 -m pip install --no-cache-dir --upgrade pip && \
	pip3 install --no-cache-dir --upgrade wheel && \
	pip3 install --no-cache-dir -r requirements.txt && \
	apk del build-dependencies && \
  rm -rf /var/cache/apk/* && \
  rm -rf /root/.cache/pip && \
  find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
  find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf && \
  rm -rf /root/.cargo

#	apt-get purge -y python3-dev && \
#RUN pip install sslyze==${BUILD_VERSION}
#RUN pip3 install --no-cache-dir -r requirements.txt

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/dkimpy"
LABEL org.opencontainers.image.description="dkimpy is a library that implements DKIM (DomainKeys Identified Mail) email signing and verification"

CMD ["dkimverify"]
#CMD ["dknewkey"]
#CMD ["dkimsign"]
