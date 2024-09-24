# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d AS alpine3.20-base

# Ubuntu 24.10
FROM ubuntu:24.10@sha256:67541378af7d535606e684a8234d56ca0725b6a4d8b0bbf19cebefed98e06f42 AS ubuntu24.10-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:95af18fcbd89bafbf02988a4278167367cedefd83bec828df424f9ec6ad38035 AS almalinux9.4minimal-base

# Go 1.23 on Alpine 3.20
FROM golang:1.23.1-alpine3.20@sha256:ac67716dd016429be8d4c2c53a248d7bcdf06d34127d3dc451bda6aa5a87bc06 AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:22.9-alpine3.20@sha256:c9bb43423a6229aeddf3d16ae6aaa0ff71a0b2951ce18ec8fedb6f5d766cf286 AS node22-base

