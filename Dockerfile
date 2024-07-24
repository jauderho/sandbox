# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.2@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS alpine3.20-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:562456a05a0dbd62a671c1854868862a4687bf979a96d48ae8e766642cd911e8 AS ubuntu24.04-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:a9afd3c2d964aa05c0a8056d8073192ed6eb35fd7c7dfcfe0ca7ea6c3ca89040 AS almalinux9.4minimal-base

# Go 1.22 on Alpine 3.20
FROM golang:1.22.5-alpine3.20@sha256:8c9183f715b0b4eca05b8b3dbf59766aaedb41ec07477b132ee2891ac0110a07 AS golang1.22-base

# Node 22 on Alpine 3.20 
FROM node:22.5-alpine3.20@sha256:a5b9a7e61337e37c8b6985a661d214f519d92d13c4f01becbe8d2947935fa0da AS node22-base
