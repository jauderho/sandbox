[![Build Status](https://github.com/jauderho/dockerfiles/workflows/uv/badge.svg)](https://github.com/jauderho/dockerfiles/actions)
[![Version](https://img.shields.io/docker/v/jauderho/uv/latest)](https://github.com/astral-sh/uv/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jauderho/uv)](https://hub.docker.com/r/jauderho/uv/)
[![Image Size](https://img.shields.io/docker/image-size/jauderho/uv/latest)](https://hub.docker.com/r/jauderho/uv/)

[uv](https://github.com/astral-sh/uv) is an extremely fast Python package and
project manager, written in Rust.

## Usage

```
docker run --rm -it -v "$PWD":/data -w /data jauderho/uv:latest uv pip compile pyproject.toml
```
