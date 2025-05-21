# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.21
FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS alpine3.21-base

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:36bbb8adc0662496d3e314bc8a25cb41c0c2e42ed25daaa07f8369d36d16f082 AS ubuntu25.04-base

# Alma Linux 9.5
FROM almalinux:9.6-minimal@sha256:9ce673a3ec37e6a1f0cefe08f9ee6affd83837415ac524b5ec0593157ea3b303 AS almalinux9.5minimal-base

# Go 1.24 on Alpine 3.21
FROM golang:1.24.3-alpine3.21@sha256:ef18ee7117463ac1055f5a370ed18b8750f01589f13ea0b48642f5792b234044 AS golang1.24-base

# Node 24 on Alpine 3.21 
FROM node:24.0-alpine3.21@sha256:2e6c7937cb36d1e4af3c261b29e862205beb7a409de01f12b6df34800cc108ec AS node23-base

