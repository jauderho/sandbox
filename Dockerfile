# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.0@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:3e1fb4aeedc137fc8cffe5f0a7c25bfd216ffab624460c8c17031724d9dc61e4 AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:b353d3bd6c1b5142d943d88a8c5d452ba11687ecd68015b8f7829ac8ae456e2f AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.5-alpine3.18@sha256:5c1cabd9a3c6851a3e18735a2c133fbd8f67fe37eb3203318b7af2ffd2547095 AS golang1.21-base

# node:21-alpine3.18 
FROM node:21.4-alpine3.18@sha256:9bfaec4816d320226b1533abd5d22d6a888105ee502b820676736de99a198408 AS node21-base
