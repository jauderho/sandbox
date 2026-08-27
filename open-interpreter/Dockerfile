# open-interpreter caps tiktoken at <0.8.0, and tiktoken 0.7.x ships musl wheels
# only up to cp312 (its pyo3 0.20 cannot build against Python 3.14), so this
# cannot use the plain alpine base - Alpine 3.24 ships Python 3.14.
#FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b
FROM python:3.12-alpine3.22@sha256:a190708a2dec1bd18b1decb539f8e8f5407abaa9bf39cacda583f7f8c11db322

ARG BUILD_VERSION

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt .

RUN \
	apk update && \
	apk upgrade -a && \
	build_pkgs="build-base gcc python3-dev musl-dev linux-headers" && \
	runtime_pkgs="ca-certificates openssl" && \
	apk --no-cache add --virtual build-dependencies ${build_pkgs} && \
	apk --no-cache add ${runtime_pkgs} && \
	pip3 install --no-cache-dir -r requirements.txt && \
	apk del build-dependencies && \
	rm -rf /var/cache/apk/* && \
	rm -rf /root/.cache/pip && \
	find /usr/local/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
	find /usr/local/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf && \
	rm -rf /root/.cargo

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/open-interpreter"
LABEL org.opencontainers.image.description="Open Interpreter is a new way to use computers"

WORKDIR /data

ENTRYPOINT ["interpreter"]
CMD ["-h"]

