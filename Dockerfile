# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.3@sha256:124c7d2707904eea7431fffe91522a01e5a861a624ee31d03372cc1d138a3126 AS alpine3.17-base

# Ubuntu 23.04
FROM ubuntu:23.04@sha256:5ecfaeaaf7b0351f7ed301e389a13a6ff04f32f6e0e5e65f700b9321913b4497 AS ubuntu23.04-base

# Alma Linux 9.1
FROM almalinux:9.1-minimal@sha256:37d1d055ecc8f02a9142c82016712a797f3959da0c41c6ee93d7c2af8e0603dd AS almalinux9.1minimal-base

# Go 1.20 on Alpine 3.17
FROM golang:1.20.2-alpine3.17@sha256:576da1aa73f8ffa3dc6a7577b6032bd834aa84f2e1714d3e7e96b06b49f4e177 AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.8-alpine3.17@sha256:a67a33f791d1c86ced985f339fa160f6188f590ebbe963fe11cc00adc971fa41 AS node19-base
