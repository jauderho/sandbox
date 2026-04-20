# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:747f062616f496b0630277a9f25ce9a4d25986887ad6d6dad05cfc6f8b274d90 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:7ef941168f213aa115df2e61364d67682129e99dc8188b734139dea862cc7d31 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.9.0-alpine3.22@sha256:d4f742bdaee57b81d8b1a1c78e210e5c3c2b3892b335a30575956819028c804e AS node-base
