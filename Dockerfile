# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:dd397d3b5e4896054db111cb5145c0c08a6e7a669537e750e79e0385f2d69207 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:ae1b7fe96fd267d82e34a7086149177e2cc8192519515f27f39e9463a9b79eb7 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.4-alpine3.22@sha256:68932fa6d4d4059845c8f40ad7e654e626f3ebd3706eef7846f319293ab5cb7a AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.1-alpine3.22@sha256:91aa1bb6b5f57ec5109155332f4af2aa5d73ff7b4512c8e5dfce5dc88dbbae0e AS node-base
