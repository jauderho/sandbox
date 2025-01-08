# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.21.1@sha256:b97e2a89d0b9e4011bb88c02ddf01c544b8c781acf1f4d559e7c8f12f1047ac3 AS alpine3.21-base

# Ubuntu 24.10
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:8ecd8d4dc786dd4aa88e4c7cc1b7c2456288e600e1d53986dd21d1b118547a3c AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.20
FROM golang:1.23.4-alpine3.20@sha256:6a8532e5441593becc88664617107ed567cb6862cb8b2d87eb33b7ee750f653c AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.6-alpine3.20@sha256:908b114a5d38fee50c21ae760fbc8820325de4cd0b0b1e715885cc2a5d8827d7 AS node23-base

