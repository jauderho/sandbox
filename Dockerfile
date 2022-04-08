# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.15.3
FROM alpine:3.15.4@sha256:315a3eab8ebf3bbcb931e34d13684b1e53186b8ec342c64383ce5c64890771ab AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 21.10
#FROM ubuntu:21.10@sha256:1108598c6469492b0ec61c4c9bab6868a3d335ecf76deb4d31ff3b2615170ae9 AS ubuntu21.10-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:06b5d30fabc1fc574f2ecab87375692299d45f8f190d9b71f512deb494114e1f AS ubuntu22.04-base

# Go 1.18 on Alpine 3.15
FROM golang:1.18.0-alpine3.15@sha256:a2ca4f4c0828b1b426a3153b068bf32a21868911c57a9fc4dccdc5fbb6553b35 AS golang1.18-base

# node:16-alpine3.15 
FROM node:16-alpine3.15@sha256:2f50f4a428f8b5280817c9d4d896dbee03f072e93f4e0c70b90cc84bd1fcfe0d AS node16-alpine3.15

# node:17-alpine3.15
FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15
