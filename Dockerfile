# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:fcdea13661343a0113773e1f3c481336462222a08993a9a83eae58268746d139 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:7eb6d61ccfcde4e335b064c1da2f58993a463ec1618edbe16d1824d4eff7599f AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.6-alpine3.22@sha256:c8c5f95d64aa79b6547f3b626eb84b16a7ce18a139e3e9ca19a8c078b85ba80d AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.5-alpine3.22@sha256:e8e882c692a08878d55ec8ff6c5a4a71b3edca25eda0af4406e2a160d8a93cf2 AS node-base
