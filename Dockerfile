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
FROM golang:1.23.3-alpine3.20@sha256:09742590377387b931261cbeb72ce56da1b0d750a27379f7385245b2b058b63a AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.1-alpine3.20@sha256:1467ea23cce893347696b155b9e00e7f0ac7d21555eb6f27236f1328212e045e AS node22-base

