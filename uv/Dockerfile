FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
#FROM python:3.14.0a5-alpine3.21@sha256:85ae1b2efa2818d696ea3b1bdb1f1602db7b342b5628a977b51a41b3eec36147
#FROM python:3.14.0a5-alpine3.21@sha256:85ae1b2efa2818d696ea3b1bdb1f1602db7b342b5628a977b51a41b3eec36147

ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
ENV VIRTUAL_ENV=/usr/local

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
LABEL org.opencontainers.image.title="jauderho/uv"
LABEL org.opencontainers.image.description="uv is a fast replacement for pip, written in Rust"

#ENTRYPOINT ["uv"]
CMD ["python3"]

