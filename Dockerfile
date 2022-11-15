# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.16.0
FROM alpine:3.16.3@sha256:b95359c2505145f16c6aa384f9cc74eeff78eb36d308ca4fd902eeeb0a0b161b AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:4b1d0c4a2d2aaf63b37111f34eb9fa89fa1bf53dd6e4ca954d47caebca4005c2 AS ubuntu22.04-base

# Go 1.18 on Alpine 3.16
FROM golang:1.19.3-alpine3.16@sha256:dc4f4756a4fb91b6f496a958e11e00c0621130c8dfbb31ac0737b0229ad6ad9c AS golang1.18-base

# node:17-alpine3.15
#FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15

# node:18-alpine3.15 
FROM node:19-alpine3.15@sha256:8d87f28bd6f8a6c717e0be1defc297b22672b79820c83a7087a80548fa13d2b4 AS node18-alpine3.15
