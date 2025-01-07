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
FROM golang:1.23.4-alpine3.20@sha256:9a31ef0803e6afdf564edc8ba4b4e17caed22a0b1ecd2c55e3c8fdd8d8f68f98 AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.5-alpine3.20@sha256:0e5b53891ddbf3c4924077990f037ff55d981d030648345574cd1cb0e4a524bb AS node23-base

