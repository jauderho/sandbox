# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:23e2d6c4de2adfcbd631be39296d8eb6968e2bfbf0df86db88147f2814086bd6 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21rc3-alpine3.18@sha256:875aca5a007bc1e20fa27aa9465c26c908c1c4f9a83022dd844a9943a8953511 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.4-alpine3.18@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS node20-base
