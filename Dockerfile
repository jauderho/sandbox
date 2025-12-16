# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:12aa2ae97b9b295d28962e83cb36cb478f3afbdda68196e5fd62e68bde3a67d5 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:451d0aa4124932abd439c9dc62792ab4c388f1dc12ba219fbf761abb04afc338 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.0@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.5-alpine3.22@sha256:3587db7cc96576822c606d119729370dbf581931c5f43ac6d3fa03ab4ed85a10 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.2-alpine3.22@sha256:26ded7f450a0ad37241d2ae97ea521a59cb551a1785c8a950f74b0a291ad3aea AS node-base
