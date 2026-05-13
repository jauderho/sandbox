# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:1843302c3d8256e51225513c0452938e57f80af025f1553ad7e2ddbb30a7931c AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:be93003ee861b3b91b6ebcb22678524947e0cd786c2df3f32af520006b1e54f5 AS golang-base

# Node 24 on Alpine 3.22
FROM node:26.1.0-alpine3.22@sha256:df14c236fa02ce2e232f234d571ce831c6b67c27605ece534164822257ed256e AS node-base
