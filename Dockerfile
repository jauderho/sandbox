# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:ed5b80e7117fe03f4197adc76c64a86a290d31898a5d491e32f66c7eb7558fe3 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.0-alpine3.18@sha256:445f34008a77b0b98bf1821bf7ef5e37bb63cc42d22ee7c21cc17041070d134f AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.5-alpine3.18@sha256:f62abc08fe1004555c4f28b6793af8345a76230b21d2d249976f329079e2fef2 AS node20-base
