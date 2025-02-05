# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099 AS alpine3.21-base

# Ubuntu 25.04
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:8ecd8d4dc786dd4aa88e4c7cc1b7c2456288e600e1d53986dd21d1b118547a3c AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.21
FROM golang:1.23.6-alpine3.21@sha256:2c49857f2295e89b23b28386e57e018a86620a8fede5003900f2d138ba9c4037 AS golang1.23-base

# Node 23 on Alpine 3.21 
FROM node:23.7-alpine3.21@sha256:70eca392e3d52cb7d133b52d52e8600d8c410a5eaee6105c11324b28868f9ac9 AS node23-base

