# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:91832dcd7bc5e44c098ecefc0a251a5c5d596dae494b33fb248e01b6840f8ce0 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:827e1097d70f3c622bbd56748b09f57bc272fa2c0afa878f7b21d7fdeb263db5 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:07e91d24f6330432729082bb580983181809e0a48f0f38ecde26868d4568c6ac AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.8.2-alpine3.22@sha256:5f969e64a872f551a8c8835992c6fe898a2bf40dd814e0fec7c1a098bd2b5859 AS node-base
