# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:1041699615b625b6bb6fbcdb7876bb1379f52b954374ab457360d9444a05cd7d AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:7eb6d61ccfcde4e335b064c1da2f58993a463ec1618edbe16d1824d4eff7599f AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.0-alpine3.22@sha256:f18a072054848d87a8077455f0ac8a25886f2397f88bfdd222d6fafbb5bba440 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.7-alpine3.22@sha256:3d2d6014608a8fa9127ae9c808569fb36f2e5c362b9831127bc30c985da65a8e AS node-base
