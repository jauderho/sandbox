# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.0@sha256:8914eb54f968791faf6a8638949e480fef81e697984fba772b3976835194c6d4 AS alpine3.17-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:4b1d0c4a2d2aaf63b37111f34eb9fa89fa1bf53dd6e4ca954d47caebca4005c2 AS ubuntu22.04-base

# Go 1.19 on Alpine 3.17
FROM golang:1.19.3-alpine3.17@sha256:8bd8a4b55b233ea77a81250f83637553ef9e3348c5a0cc3ce440c5d45bf7d51d AS golang1.19-base

# node:19-alpine3.16 
FROM node:19.2-alpine3.16@sha256:80844b6643f239c87fceae51e6540eeb054fc7114d979703770ec75250dcd03b AS node19-base
