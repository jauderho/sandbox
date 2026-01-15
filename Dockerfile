# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:12aa2ae97b9b295d28962e83cb36cb478f3afbdda68196e5fd62e68bde3a67d5 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:4f02be934419e0cc0b89f95be6463be8a7736eb75017f99ab66c9b0c59680cc6 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.5-alpine3.22@sha256:3587db7cc96576822c606d119729370dbf581931c5f43ac6d3fa03ab4ed85a10 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.3-alpine3.22@sha256:e7b37edfbf338dad4a48ac77b072a78afd06728dffe8c1803fd9f5cd2d4c1dc8 AS node-base
