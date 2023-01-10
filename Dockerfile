# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.1@sha256:f271e74b17ced29b915d351685fd4644785c6d1559dd1f2d4189a5e851ef753a AS alpine3.17-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:4b1d0c4a2d2aaf63b37111f34eb9fa89fa1bf53dd6e4ca954d47caebca4005c2 AS ubuntu22.04-base

# Go 1.19 on Alpine 3.17
FROM golang:1.19.4-alpine3.17@sha256:86d32cc0dfc04757fd8aeebb86308e6d1e3de60c73cb59e0f99c7b2ef77416b6 AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.4-alpine3.17@sha256:ab3603cb7934b21f1ffb522b1a1d538809516c6e4cd73b144716bc1830aad1a6 AS node19-base
