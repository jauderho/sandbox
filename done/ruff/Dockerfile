FROM ghcr.io/jauderho/alpine:3.21.3@sha256:8139b5dd95ef46202c45b611a4b7e972defda480df2e058b95b6a07b4f2e96c4
#FROM python:3.13.0b1-alpine3.19@sha256:f2028c7ea4005bfa797d91717dc8f5f8990bb592d10d5b014513ac4405f99267

ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN \
	apk update && \
	apk upgrade -a && \
	build_pkgs="" && \
	runtime_pkgs="ca-certificates openssl python3 py3-pip" && \
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
LABEL org.opencontainers.image.title="jauderho/ruff"
LABEL org.opencontainers.image.description="ruff is an extremely fast Python linter and code formatter, written in Rust"

WORKDIR /data

ENTRYPOINT ["ruff"]
CMD ["-h"]

