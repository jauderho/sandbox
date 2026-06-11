# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.2-minimal@sha256:bafd259fb7b0475eed28376ddddea19f209e24efafc9eb21f4e9d5ed9825d2ef AS almalinux-base

# Alpine 3.22
FROM alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26.4-alpine3.22@sha256:727cfc3c40be55cd1bc9a4a059406b28a059857e3be752aa9d09531e12c20c56 AS golang-base

# Node 24 on Alpine 3.22
FROM node:26.3.0-alpine3.22@sha256:c7932b9e5e337b0e733d6e16abc1b0e104759e8b05e59ed56586cce967d26dfe AS node-base
