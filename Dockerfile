# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.15.4
FROM alpine:3.16.0@sha256:686d8c9dfa6f3ccfc8230bc3178d23f84eeaf7e457f36f271ab1acc53015037c AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:26c68657ccce2cb0a31b330cb0be2b5e108d467f641c62e13ab40cbec258c68d AS ubuntu22.04-base

# Go 1.18 on Alpine 3.15
FROM golang:1.18.3-alpine3.15@sha256:f9181168749690bddb6751b004e976bf5d427425e0cfb50522e92c06f761def7 AS golang1.18-base

# node:17-alpine3.15
#FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15

# node:18-alpine3.15 
FROM node:18-alpine3.15@sha256:0677e437543d10f6cb050d92c792a14e5eb84340e3d5b4c25a88baa723d8a4ae AS node18-alpine3.15
