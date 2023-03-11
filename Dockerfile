# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.2@sha256:69665d02cb32192e52e07644d76bc6f25abeb5410edc1c7a81a10ba3f0efb90a AS alpine3.17-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:4b1d0c4a2d2aaf63b37111f34eb9fa89fa1bf53dd6e4ca954d47caebca4005c2 AS ubuntu22.04-base

# Alma Linux 9.1
FROM almalinux:9.1-minimal@sha256:565f87aeb5da6481e497788347cd57ebf5b19df42ac5a67a5bdf4d044ddb9a69 AS almalinux9.1minimal-base

# Go 1.19 on Alpine 3.17
FROM golang:1.20.1-alpine3.17@sha256:48f336ef8366b9d6246293e3047259d0f614ee167db1869bdbc343d6e09aed8a AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.7-alpine3.17@sha256:4a3a2ccfa801ce6960e7fc29fc5e5a1ed896b633e4731cdb87b4e1a1e9ad246e AS node19-base
