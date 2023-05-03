# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.3@sha256:124c7d2707904eea7431fffe91522a01e5a861a624ee31d03372cc1d138a3126 AS alpine3.17-base

# Ubuntu 23.04
FROM ubuntu:23.04@sha256:db2764b64a490a9ce44a7ce0c7ba7cc6d0472c8c44684960dbca7a06525eb597 AS ubuntu23.04-base

# Alma Linux 9.1
FROM almalinux:9.1-minimal@sha256:37d1d055ecc8f02a9142c82016712a797f3959da0c41c6ee93d7c2af8e0603dd AS almalinux9.1minimal-base

# Go 1.20 on Alpine 3.17
FROM golang:1.20.4-alpine3.17@sha256:913de96707b0460bcfdfe422796bb6e559fc300f6c53286777805a9a3010a5ea AS golang1.20-base

# node:19-alpine3.17 
FROM node:20.0-alpine3.17@sha256:1d34273b1b489a4e879ccfaee83c1cec99acbb5a4128f880981071e1bae62b97 AS node19-base
