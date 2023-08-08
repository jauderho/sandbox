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
FROM golang:1.21rc4-alpine3.18@sha256:3af894a0574b1d0ce39269b21809063d58f6bc6f99bd2061159e3cb4a54e47eb AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.5-alpine3.18@sha256:59ecf4c430fc6e15b3e6f2ee3ae8fa9773b2508856baf376fcd9ad7b1e6934a9 AS node20-base
