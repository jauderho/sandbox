FROM ghcr.io/astral-sh/uv:0.12.17@sha256:10787c682e4184e4f290de1171fd4703dc63de99221f10fe1c99002ce7fa9acc AS uv


# --------------------------------------------------------------------------


FROM ubuntu:26.10@sha256:6a2abc30a3e00fa62e756ddff3698def66314e29fab5fc851d7f298ffda17449 AS build

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

# uv installs into a venv, so PEP 668 does not apply and neither
# --break-system-packages nor --ignore-installed is needed any more.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY --from=uv /uv /usr/local/bin/uv
COPY pyproject.toml uv.lock ./

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends python3 && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3 && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf


# --------------------------------------------------------------------------


FROM ubuntu:26.10@sha256:6a2abc30a3e00fa62e756ddff3698def66314e29fab5fc851d7f298ffda17449

ARG DEBIAN_FRONTEND=noninteractive

# the venv symlinks its interpreter, so python3 must be at the same path
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends ca-certificates python3 && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

# smoke test, then drop the bytecode the test run just generated
RUN python3 -c 'import chromadb' && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/llama-fs"
LABEL org.opencontainers.image.description="Runtime environment for llama-fs, a self-organizing file system"

WORKDIR /data

# Upstream llama-fs ships no pyproject.toml or setup.py, so it cannot be
# installed as a package and provides no console script. This image carries its
# dependencies instead; mount the checkout and run server.py against it. The
# image previously ran "llama-fs", which it does not contain.
ENTRYPOINT ["python3"]
