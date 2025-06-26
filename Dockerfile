# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:dd397d3b5e4896054db111cb5145c0c08a6e7a669537e750e79e0385f2d69207 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:9cdcbb8b9b0e522e4c190d4f1db67ebd443736630ad77cf2263ba86d0870bf1b AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.4-alpine3.22@sha256:68932fa6d4d4059845c8f40ad7e654e626f3ebd3706eef7846f319293ab5cb7a AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.3-alpine3.22@sha256:49e45bf002728e35c3a466737d8bcfe12c29731c7c2f3e223f9a7c794fff19a4 AS node-base
