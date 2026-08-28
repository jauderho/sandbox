FROM ghcr.io/jauderho/alpine:3.24.1@sha256:f310f8a4fad676899731a97c5eaf004c9cb9e822018a2ad7d23c3aeda3a7d773 AS build

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


FROM ghcr.io/jauderho/alpine:3.24.1@sha256:f310f8a4fad676899731a97c5eaf004c9cb9e822018a2ad7d23c3aeda3a7d773

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
RUN pipenv-poetry-migrate --help > /dev/null && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/pipenv-poetry-migrate"
LABEL org.opencontainers.image.description="Simple migration script to migrate from pipenv to poetry"

WORKDIR /data

ENTRYPOINT ["pipenv-poetry-migrate"]
CMD ["-h"]
