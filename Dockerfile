# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:901617b8bedb2c5063400661137388b26239253c10788a9f211d086e0c12ea7e AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:451d0aa4124932abd439c9dc62792ab4c388f1dc12ba219fbf761abb04afc338 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.4-alpine3.22@sha256:d3f0cf7723f3429e3f9ed846243970b20a2de7bae6a5b66fc5914e228d831bbb AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.2-alpine3.22@sha256:26ded7f450a0ad37241d2ae97ea521a59cb551a1785c8a950f74b0a291ad3aea AS node-base
