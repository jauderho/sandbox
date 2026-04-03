# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:730382b4a53a3c4a1498b7a36f11a62117f133fe6e73b01bb91303ed2ad87cdd AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:827e1097d70f3c622bbd56748b09f57bc272fa2c0afa878f7b21d7fdeb263db5 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:07e91d24f6330432729082bb580983181809e0a48f0f38ecde26868d4568c6ac AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.9.0-alpine3.22@sha256:45ee7adabf5073b70c18746ef34be804077b8f5fa09d0188c19697590463b53e AS node-base
