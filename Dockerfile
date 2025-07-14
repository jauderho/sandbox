# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:10b61aabaaf0123f3670112057c3b3ccf27c808ddb892ba5a4e32366bff7f3fe AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:56d2971a2597628fe3e933fb400eb85f832f7d27459b016a138bc739b8aba185 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.5-alpine3.22@sha256:ddf52008bce1be455fe2b22d780b6693259aaf97b16383b6372f4b22dd33ad66 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.4-alpine3.22@sha256:22b3c1a1171c798c0429f36272922dbb356bbab8a6d11b3b095a143d3321262a AS node-base
