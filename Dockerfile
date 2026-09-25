# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 26.04
FROM ubuntu:26.04@sha256:cd21a4f68a617580279d4b091cb18e3af9fa8a87500665f0ae5f7f757d17d367 AS ubuntu-base

# Alma Linux 10.2
FROM almalinux:10.2-minimal@sha256:77aeeeef6889af731a91d83f65b08ef9930bde10332ae2e3fd6e0f0c47066a7b AS almalinux-base

# Alpine 3.24
FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS alpine-base

# Go 1.26 on Alpine 3.24
FROM golang:1.26.4-alpine3.22@sha256:727cfc3c40be55cd1bc9a4a059406b28a059857e3be752aa9d09531e12c20c56 AS golang-base

# Node 26 on Alpine 3.24
FROM node:26.9.0-alpine3.24@sha256:dbaa92e5758cbbcf85d65d5403fdb530fe3442cbe8c6dbfb7ef23365450d5070 AS node-base
