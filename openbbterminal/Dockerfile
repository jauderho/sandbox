FROM ghcr.io/astral-sh/uv:0.13.8@sha256:5cc1805e2426484abca4ad46ea783bab281fdb225fd82d8ce6d66a81254bac85 AS uv


# ----------------------------------------------------------------------------


FROM ubuntu:26.10@sha256:b5194b8e58989da0865ebc80078bf9f5f8742ec6a867c53f6ae699f6036756f7 AS build

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

# uv installs into a venv, so PEP 668 does not apply. That also removes the need
# for --ignore-installed, which was only there to work around pip being unable
# to uninstall the distro copies of pip and packaging.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY --from=uv /uv /usr/local/bin/uv
COPY pyproject.toml uv.lock ./

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends \
		git python3 python3-dev build-essential gfortran && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3 && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf


# ----------------------------------------------------------------------------


FROM ubuntu:26.10@sha256:b5194b8e58989da0865ebc80078bf9f5f8742ec6a867c53f6ae699f6036756f7

ARG DEBIAN_FRONTEND=noninteractive

# the venv symlinks its interpreter, so python3 has to be at the same path here.
# the compiler toolchain stays in the build stage - the previous single stage
# build shipped build-essential and gfortran in the final image.
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends python3 && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

# smoke test, then drop the bytecode the test run just generated
RUN openbb --help > /dev/null && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/openbbterminal"
LABEL org.opencontainers.image.description="OpenBBTerminal is an awesome stock and crypto market terminal"

ENTRYPOINT ["openbb"]
