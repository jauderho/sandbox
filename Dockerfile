# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:24.04@sha256:3e1fb4aeedc137fc8cffe5f0a7c25bfd216ffab624460c8c17031724d9dc61e4 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.3-minimal@sha256:b353d3bd6c1b5142d943d88a8c5d452ba11687ecd68015b8f7829ac8ae456e2f AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.4-alpine3.18@sha256:70afe55365a265f0762257550bc38440e0d6d6b97020d3f8c85328f00200dd8e AS golang1.21-base

# node:20-alpine3.18 
FROM node:21.3-alpine3.18@sha256:3dab5cc219983a5f1904d285081cceffc9d181e64bed2a4a18855d2d62c64ccb AS node20-base
