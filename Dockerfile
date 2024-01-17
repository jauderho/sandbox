# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.0@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:38d380071057443ebb6d65566c03a98eaec411e84e04e5e16cff49b1d6fdc9a0 AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:b353d3bd6c1b5142d943d88a8c5d452ba11687ecd68015b8f7829ac8ae456e2f AS almalinux9.3minimal-base

# Go 1.21 on Alpine 3.19
FROM golang:1.21.6-alpine3.19@sha256:fd78f2fb1e49bcf343079bbbb851c936a18fc694df993cbddaa24ace0cc724c5 AS golang1.21-base

# node:21-alpine3.18 
FROM node:21.6-alpine3.18@sha256:d5759af7e7ff1b9a4ba08acd2830c99021ba406f105b0ab1f561bc54a68c19d5 AS node21-base
