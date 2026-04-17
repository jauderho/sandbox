# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:cc925e589b7543b910fea57a240468940003fbfc0515245a495dd0ad8fe7cef1 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:747f062616f496b0630277a9f25ce9a4d25986887ad6d6dad05cfc6f8b274d90 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:c259ff7ffa06f1fd161a6abfa026573cf00f64cfd959c6d2a9d43e3ff63e8729 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.9.0-alpine3.22@sha256:d4f742bdaee57b81d8b1a1c78e210e5c3c2b3892b335a30575956819028c804e AS node-base
