# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:fed6ddb82c61194e1814e93b59cfcb6759e5aa33c4e41bb3782313c2386ed6df AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:7e4fd6b1a34ef63762ff03a48cefad1e5ca8660c18d1dc850023d44fde73587c AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:07e91d24f6330432729082bb580983181809e0a48f0f38ecde26868d4568c6ac AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.8.0-alpine3.22@sha256:c99914daead7f253591594bc6485315f551f785aa31f73c3f189d4c5f9f366d0 AS node-base
