# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d AS alpine3.20-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:8a37d68f4f73ebf3d4efafbcf66379bf3728902a8038616808f04e34a9ab63ee AS ubuntu24.04-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:a9afd3c2d964aa05c0a8056d8073192ed6eb35fd7c7dfcfe0ca7ea6c3ca89040 AS almalinux9.4minimal-base

# Go 1.22 on Alpine 3.20
FROM golang:1.23.1-alpine3.20@sha256:ac67716dd016429be8d4c2c53a248d7bcdf06d34127d3dc451bda6aa5a87bc06 AS golang1.22-base

# Node 22 on Alpine 3.20 
FROM node:22.8-alpine3.20@sha256:bec0ea49c2333c429b62e74e91f8ba1201b060110745c3a12ff957cd51b363c6 AS node22-base
