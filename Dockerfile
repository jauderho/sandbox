# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:4095ef613201918336b5d7d00be15d8b09c72ddb77c80bca249c255887a64d87 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:4f02be934419e0cc0b89f95be6463be8a7736eb75017f99ab66c9b0c59680cc6 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26rc2-alpine3.22@sha256:43583f46bf6dfe7c90fd1f0ac7b37ea9c2803686cc5c3a919b1a34109a3127ab AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.5-alpine3.22@sha256:498491bb9e96cab862a2e5071556d3fb3159ca2a854aedd53abd0e364856d70b AS node-base
