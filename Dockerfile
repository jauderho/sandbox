# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:4095ef613201918336b5d7d00be15d8b09c72ddb77c80bca249c255887a64d87 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:7e4fd6b1a34ef63762ff03a48cefad1e5ca8660c18d1dc850023d44fde73587c AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:169d3991a4f795124a88b33c73549955a3d856e26e8504b5530c30bd245f9f1b AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.6.1-alpine3.22@sha256:c8af94bce6bac00d76200a0f22535d5cb261a58515e0a3c804ebde07ef298970 AS node-base
