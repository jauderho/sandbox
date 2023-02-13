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
FROM golang:1.20.0-alpine3.17@sha256:1e2917143ce7e7bf8d1add2ac5c5fa3d358b2b5ddaae2bd6f54169ce68530ef0 AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.6-alpine3.17@sha256:992dd138340c189b2bc49d879cc4b328b12b8aa3480a43b1a05505a18987df3b AS node19-base
