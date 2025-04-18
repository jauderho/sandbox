#FROM debian:latest
FROM ubuntu:25.04@sha256:79efa276fdefa2ee3911db29b0608f8c0561c347ec3f4d4139980d43b168d991

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

RUN python3 -m venv /venv

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements-test.txt requirements-extra.txt requirements-docs.txt /tmp/

RUN $PYTHON -m pip install --no-cache-dir -U \
    -r /tmp/requirements-extra.txt \
    -r /tmp/requirements-test.txt \
    -r /tmp/requirements-docs.txt \
    cython \
    setuptools \
    wheel

RUN npm install -g prettier

RUN ln -f -s /usr/bin/ccache /bin/g++ \
    && ln -f -s /usr/bin/ccache /bin/gcc

WORKDIR /src
