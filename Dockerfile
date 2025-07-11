# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:10b61aabaaf0123f3670112057c3b3ccf27c808ddb892ba5a4e32366bff7f3fe AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:9cdcbb8b9b0e522e4c190d4f1db67ebd443736630ad77cf2263ba86d0870bf1b AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.5-alpine3.22@sha256:ddf52008bce1be455fe2b22d780b6693259aaf97b16383b6372f4b22dd33ad66 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.4-alpine3.22@sha256:9e78ba94eacc1d433b421634f9d0b407b6d2a7eaddc640d5b7e1b725653c90da AS node-base
