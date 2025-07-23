# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:10b61aabaaf0123f3670112057c3b3ccf27c808ddb892ba5a4e32366bff7f3fe AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:a6b2c1d34ae5cb828e67003dce51ea65b1a0b0ff05538070d9e172695002f497 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.5-alpine3.22@sha256:48ee313931980110b5a91bbe04abdf640b9a67ca5dea3a620f01bacf50593396 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.4-alpine3.22@sha256:820e86612c21d0636580206d802a726f2595366e1b867e564cbc652024151e8a AS node-base
