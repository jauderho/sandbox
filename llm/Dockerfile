FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS build

ARG BUILD_VERSION

# uv installs into a venv, so PEP 668 does not apply and
# --break-system-packages is no longer needed. uv comes from the alpine
# community repo because ghcr.io/astral-sh/uv is amd64/arm64 only.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY pyproject.toml uv.lock ./

RUN \
	apk update && \
	apk upgrade -a && \
	apk --no-cache add python3 uv && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3 && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf


# --------------------------------------------------------------------------


FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# the venv symlinks its interpreter, so python3 must be at the same path
RUN \
	apk update && \
	apk upgrade -a && \
	apk --no-cache add ca-certificates openssl python3 && \
	rm -rf /var/cache/apk/* && \
	find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
	find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

# smoke test, then drop the bytecode the test run just generated
RUN llm --version && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/llm"
LABEL org.opencontainers.image.description="llm is a CLI for interacting with Large Language Models"

WORKDIR /data

ENTRYPOINT ["llm"]
CMD ["prompt","--help"]
