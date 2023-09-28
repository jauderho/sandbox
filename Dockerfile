# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:c1c5a248f628c287d3472d86b0e5c9ca2ef0280475e50b46ad371f566b72e680 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.1-alpine3.18@sha256:ec31b7fbaf32583af4f4f8c9e0cabc651247624bf962adbb7fa1b54c9c03d5e4 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.7-alpine3.18@sha256:a329b146bcc99a36caa73056e60714d0911ca5c229ade3eb27e9283dc78c9eb6 AS node20-base
