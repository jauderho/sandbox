# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:2c12b887bd41265d2a3a5e993060c9da28dfc7eaab138c908aec196e087a3c86 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21rc4-alpine3.18@sha256:3af894a0574b1d0ce39269b21809063d58f6bc6f99bd2061159e3cb4a54e47eb AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.5-alpine3.18@sha256:d0b7a0bb4d1f3d4f49988541caebcfa4408892288e93097e4b89c92131163234 AS node20-base
