# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:0a5031f14cddcb70dd8ebdfed2e0cb5a56242653f50d430cbe083554a1154387 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:7ef941168f213aa115df2e61364d67682129e99dc8188b734139dea862cc7d31 AS golang-base

# Node 24 on Alpine 3.22
FROM node:26.0.0-alpine3.22@sha256:ce348069f9636e54da6f6e222565bf37953cc97fcc0a5e061257a87c43b91483 AS node-base
