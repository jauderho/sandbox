# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.21
FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS alpine3.21-base

# Ubuntu 25.04
FROM ubuntu:25.04@sha256:008b026f11c0b5653d564d0c9877a116770f06dfbdb36ca75c46fd593d863cbc AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:bde69332d9f27f4baef07c85dbff64bc34aaa678871680d57cf7b0ffa2becd06 AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.21
FROM golang:1.24.1-alpine3.21@sha256:43c094ad24b6ac0546c62193baeb3e6e49ce14d3250845d166c77c25f64b0386 AS golang1.24-base

# Node 23 on Alpine 3.21 
FROM node:23.10-alpine3.21@sha256:6eae672406a2bc8ed93eab6f9f76a02eb247e06ba82b2f5032c0a4ae07e825ba AS node23-base

