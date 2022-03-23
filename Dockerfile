# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.15.0
FROM alpine:3.15.1@sha256:d6d0a0eb4d40ef96f2310ead734848b9c819bb97c9d846385c4aca1767186cd4 AS alpine3.15-base

# Ubuntu 20.04
FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 21.10
FROM ubuntu:21.10@sha256:1108598c6469492b0ec61c4c9bab6868a3d335ecf76deb4d31ff3b2615170ae9 AS ubuntu21.10-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:a02c32cf0c2a7e8743c74deef66637aa70e063c9bd40e9e1f8c0b3ea0750b0ba AS ubuntu22.04-base

# Go 1.18 on Alpine 3.15
FROM golang:1.18.0-alpine3.15@sha256:9ccb0ed869157f3b1630f5dda3422b5974defa9dd82c7375ca68dc3a9cbf8fae AS golang1.18-base

# node:16-alpine3.15 
FROM node:16-alpine3.15@sha256:2f50f4a428f8b5280817c9d4d896dbee03f072e93f4e0c70b90cc84bd1fcfe0d AS node16-alpine3.15

# node:17-alpine3.15
FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15
