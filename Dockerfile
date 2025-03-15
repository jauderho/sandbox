# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS alpine3.21-base

# Ubuntu 25.04
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:bde69332d9f27f4baef07c85dbff64bc34aaa678871680d57cf7b0ffa2becd06 AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.21
FROM golang:1.24.1-alpine3.21@sha256:43c094ad24b6ac0546c62193baeb3e6e49ce14d3250845d166c77c25f64b0386 AS golang1.23-base

# Node 23 on Alpine 3.21 
FROM node:23.10-alpine3.21@sha256:45851518572a546153e942ea7a0b09e664da1f54cfb4ac20e3a86c37c7da4233 AS node23-base

