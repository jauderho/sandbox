# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a AS alpine3.20-base

# Ubuntu 24.10
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu24.10-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:95af18fcbd89bafbf02988a4278167367cedefd83bec828df424f9ec6ad38035 AS almalinux9.4minimal-base

# Go 1.23 on Alpine 3.20
FROM golang:1.23.3-alpine3.20@sha256:c694a4d291a13a9f9d94933395673494fc2cc9d4777b85df3a7e70b3492d3574 AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.2-alpine3.20@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS node22-base

