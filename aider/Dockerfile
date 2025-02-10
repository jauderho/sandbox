FROM ghcr.io/jauderho/alpine:3.21.2@sha256:e7f3117165afa2d56675922cdb717f94b22f724b385e07bfa096ede4ee58c323
#FROM python:3.14.0a4-alpine3.21@sha256:88a0650af531a0650ad135e034bbba883014430d768ad12133ba9753e267a353

ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN \
	apk update && \
	apk upgrade -a && \
	build_pkgs="build-base python3-dev musl-dev linux-headers" && \
	runtime_pkgs="ca-certificates openssl python3 py3-pip git pandoc-cli" && \
	apk --no-cache add --virtual build-dependencies ${build_pkgs} && \
	apk --no-cache add ${runtime_pkgs} && \
	#python3 -m pip install --no-cache-dir --upgrade pip --break-system-packages && \
	#pip3 install --no-cache-dir --upgrade wheel --break-system-packages && \
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
LABEL org.opencontainers.image.title="jauderho/aider"
LABEL org.opencontainers.image.description="Aider is AI pair programming in your terminal"

WORKDIR /data

ENTRYPOINT ["aider"]
CMD ["-h"]

