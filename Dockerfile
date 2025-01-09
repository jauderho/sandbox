# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099 AS alpine3.21-base

# Ubuntu 24.10
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:8ecd8d4dc786dd4aa88e4c7cc1b7c2456288e600e1d53986dd21d1b118547a3c AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.20
FROM golang:1.23.4-alpine3.20@sha256:2314d93ea3899b8118d11ec70714e96c4bb2d52ff46ee919622269a5c6207077 AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.6-alpine3.20@sha256:908b114a5d38fee50c21ae760fbc8820325de4cd0b0b1e715885cc2a5d8827d7 AS node23-base

