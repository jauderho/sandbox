FROM alpine:3.20.0@sha256:f08d666161afe0114ee8e925b254456eb79e2ece8a52d7a8979199bfd4fc3ed2

ARG BUILDKIT_SBOM_SCAN_STAGE=true
ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt .visidatarc ./ 

RUN \
	apk update && \
	apk upgrade -a && \
	build_pkgs="cargo build-base libffi-dev openssl-dev python3-dev" && \
	runtime_pkgs="ca-certificates openssl python3 py3-pip" && \
	apk --no-cache add --virtual build-dependencies ${build_pkgs} && \
	apk add --no-cache ${runtime_pkgs} && \
	python3 -m pip install --no-cache-dir --upgrade pip --break-system-packages && \
	pip3 install --no-cache-dir --upgrade wheel --break-system-packages && \
	pip3 install --no-cache-dir -r requirements.txt --break-system-packages && \
	apk del build-dependencies && \
	rm -rf /var/cache/apk/* && \
	rm -rf /root/.cache/pip && \
	find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
	find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf && \
	rm -rf /root/.cargo

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/visidata"
LABEL org.opencontainers.image.description="Visidata is a terminal interface for exploring and arranging tabular data"

WORKDIR /work

ENV TERM="xterm-256color"
HEALTHCHECK NONE

ENTRYPOINT ["vd"]

