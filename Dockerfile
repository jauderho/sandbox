# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:18bd5e273e139bdcee3a3c38b711ec140d20b74f9f005e3df0f21185f8870cfa AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:4f02be934419e0cc0b89f95be6463be8a7736eb75017f99ab66c9b0c59680cc6 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26rc2-alpine3.22@sha256:9cdde6d36f579aed530b070137a2ae7e42a936a3289152ce40f49b17409860e1 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.4-alpine3.22@sha256:10afe67a3dcc310863d335778dd6dd8d24224344b129a086219daad45936f42c AS node-base
