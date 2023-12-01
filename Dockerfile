# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:4c32aacd0f7d1d3a29e82bee76f892ba9bb6a63f17f9327ca0d97c3d39b9b0ee AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.3-minimal@sha256:b353d3bd6c1b5142d943d88a8c5d452ba11687ecd68015b8f7829ac8ae456e2f AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.4-alpine3.18@sha256:a2043ef0528eeb3cb9884b703794ad472930e4dcd109490cddf8b5cf519efa17 AS golang1.21-base

# node:20-alpine3.18 
FROM node:21.2-alpine3.18@sha256:4a512d1538b1a8281b58cab0b366a5c62436566bb63e7dcd4a6769c98edb3b5f AS node20-base
