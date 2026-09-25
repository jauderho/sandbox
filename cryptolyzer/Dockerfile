FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS build

ARG BUILD_VERSION

# uv resolves and installs into a venv, so PEP 668 never applies and
# --break-system-packages is not needed. The venv is the only build output.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY pyproject.toml uv.lock ./

# uv comes from the alpine community repo rather than ghcr.io/astral-sh/uv
# because that image only publishes amd64/arm64 and this builds 4 arches.
RUN \
	apk update && \
	apk upgrade -a && \
	apk --no-cache add python3 uv && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3 && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
	find /opt/venv -name '*.pyc' -print0 | xargs -0 -n1 rm -rf


# ----------------------------------------------------------------------------


FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

# the venv symlinks its interpreter, so python3 has to be at the same path here
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
RUN cryptolyze --version && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/cryptolyzer"
LABEL org.opencontainers.image.description="cryptolyzer is a comprehensive cryptographic settings analyzer"

WORKDIR /data

ENTRYPOINT ["cryptolyze"]
CMD ["-h"]
