FROM ghcr.io/astral-sh/uv:0.12.8@sha256:d1cbaeadc234fe19c0d93daabcf5e98738cd93c6d1dd4918ef6aa30735feb23a AS uv


# --------------------------------------------------------------------------


#FROM debian:latest
FROM ubuntu:26.04@sha256:2260313b31c8c011cd2eebe728008efac1b3982be73eb71348ea2648d2c0e09b

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    libunwind-dev \
    pkg-config \
    python3-dev \
    python3-dbg \
    python3-pip \
    python3-venv \
    make \
    cmake \
    gdb \
    valgrind \
    lcov \
    nodejs \
    npm \
    clang-format \
    git \
    ccache \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHON=/venv/bin/python \
    VIRTUAL_ENV=/venv \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/bin:$PATH \
    CC=gcc \
    CXX=g++

RUN --mount=from=uv,source=/uv,target=/usr/local/bin/uv uv venv --python /usr/bin/python3 /venv

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements-test.txt requirements-extra.txt requirements-docs.txt /tmp/

# uv is bind mounted rather than copied in, so its binary never lands in a layer
RUN --mount=from=uv,source=/uv,target=/usr/local/bin/uv \
    uv pip install --python $PYTHON --no-cache -U \
    -r /tmp/requirements-extra.txt \
    -r /tmp/requirements-test.txt \
    -r /tmp/requirements-docs.txt \
    cython \
    memray \
    setuptools \
    wheel

RUN npm install -g prettier

RUN ln -f -s /usr/bin/ccache /bin/g++ \
    && ln -f -s /usr/bin/ccache /bin/gcc

# smoke test. This image is a development environment for building memray from
# source, so it used to carry the toolchain and the test deps but not memray
# itself, and nothing here could be run. Profile a throwaway script rather than
# only asking for the version, so the gate covers the way the image gets used:
# memray run to capture, then a reporter to read the capture back.
RUN memray --version \
 && printf 'data = [object() for _ in range(200000)]\n' > /tmp/smoke.py \
 && memray run -o /tmp/smoke.bin /tmp/smoke.py \
 && memray summary /tmp/smoke.bin > /dev/null \
 && memray flamegraph -o /tmp/smoke.html /tmp/smoke.bin \
 && rm -f /tmp/smoke.py /tmp/smoke.bin /tmp/smoke.html

WORKDIR /src

# No ENTRYPOINT, so the image still works as a shell for building memray from
# source. CMD only makes a bare "docker run" say something useful.
CMD ["memray", "--help"]
