# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:2c12b887bd41265d2a3a5e993060c9da28dfc7eaab138c908aec196e087a3c86 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21rc4-alpine3.18@sha256:5ea6526bdfd433b6533575247c02671815a7998531f42dbbcb6dc2553f04f2d1 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.5-alpine3.18@sha256:d0b7a0bb4d1f3d4f49988541caebcfa4408892288e93097e4b89c92131163234 AS node20-base
