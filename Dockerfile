# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0 AS alpine3.20-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:562456a05a0dbd62a671c1854868862a4687bf979a96d48ae8e766642cd911e8 AS ubuntu24.04-base

# Alma Linux 9.4
FROM almalinux:9.4-minimal@sha256:9181cd1f824d7f22b73bda9af014fe2174ce8915bc4bf52c061dccd904f6b82c AS almalinux9.4minimal-base

# Go 1.22 on Alpine 3.20
FROM golang:1.22.5-alpine3.20@sha256:8c9183f715b0b4eca05b8b3dbf59766aaedb41ec07477b132ee2891ac0110a07 AS golang1.22-base

# Node 22 on Alpine 3.20 
FROM node:22.5-alpine3.20@sha256:f200d5ce9f0c43df6f3a6b97b692f998cce270f1409864de5fbb2e61836121f2 AS node22-base
