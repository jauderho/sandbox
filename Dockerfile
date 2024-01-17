# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.0@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:50cb325cf61fa0ac0f42c2ea431d8ef091fe3d36f5bc039d15f89c569ff4988e AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:b353d3bd6c1b5142d943d88a8c5d452ba11687ecd68015b8f7829ac8ae456e2f AS almalinux9.3minimal-base

# Go 1.21 on Alpine 3.19
FROM golang:1.21.6-alpine3.19@sha256:fd78f2fb1e49bcf343079bbbb851c936a18fc694df993cbddaa24ace0cc724c5 AS golang1.21-base

# node:21-alpine3.18 
FROM node:21.5-alpine3.18@sha256:6957aef644eecebcd8692f4b91b413b26d25a68c3dfbb6f20d29475d05c32473 AS node21-base
