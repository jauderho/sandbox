# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:a61c057b4f69200ecf031519a20db79b8683837ba1dc2a59458d333eb75b174d AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:cd55007b9804e36134bf488df6437171615c7a318addb13dd762375b39ef5629 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.2-alpine3.22@sha256:6104e2bbe9f6a07a009159692fe0df1a97b77f5b7409ad804b17d6916c635ae5 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.9-alpine3.22@sha256:77f3c4d1f33c17dfa4af4b0add57d86957187873e313c2c37f52831d117645c8 AS node-base
