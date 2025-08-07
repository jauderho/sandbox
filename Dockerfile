# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:10b61aabaaf0123f3670112057c3b3ccf27c808ddb892ba5a4e32366bff7f3fe AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:7eb6d61ccfcde4e335b064c1da2f58993a463ec1618edbe16d1824d4eff7599f AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.5-alpine3.22@sha256:daae04ebad0c21149979cd8e9db38f565ecefd8547cf4a591240dc1972cf1399 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.5-alpine3.22@sha256:e8e882c692a08878d55ec8ff6c5a4a71b3edca25eda0af4406e2a160d8a93cf2 AS node-base
