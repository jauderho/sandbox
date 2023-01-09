# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.0@sha256:8914eb54f968791faf6a8638949e480fef81e697984fba772b3976835194c6d4 AS alpine3.17-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:4b1d0c4a2d2aaf63b37111f34eb9fa89fa1bf53dd6e4ca954d47caebca4005c2 AS ubuntu22.04-base

# Go 1.19 on Alpine 3.17
FROM golang:1.19.4-alpine3.17@sha256:a9b24b67dc83b3383d22a14941c2b2b2ca6a103d805cac6820fd1355943beaf1 AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.4-alpine3.17@sha256:88e1842dc5fa44e40aea2d097685612c15c5f32b18d8b55766355de53dd5d5a7 AS node19-base
