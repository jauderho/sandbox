# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.0@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd AS alpine3.20-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:562456a05a0dbd62a671c1854868862a4687bf979a96d48ae8e766642cd911e8 AS ubuntu24.04-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:81a52f8b60623320755e52c3a010feb99ff35d9e6c0d58db9ad9a0bfc2f7a6b8 AS almalinux9.4minimal-base

# Go 1.22 on Alpine 3.19
FROM golang:1.22.3-alpine3.19@sha256:f1fe698725f6ed14eb944dc587591f134632ed47fc0732ec27c7642adbe90618 AS golang1.22-base

# node:22.2-alpine3.19 
FROM node:22.2-alpine3.19@sha256:e6d449575e1696cbaee6ec1adce2ac220dc138c4b7bc053379b53c68a6bd2799 AS node22-base
