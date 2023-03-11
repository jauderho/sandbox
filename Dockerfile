# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.17.2@sha256:69665d02cb32192e52e07644d76bc6f25abeb5410edc1c7a81a10ba3f0efb90a AS alpine3.17-base

# Ubuntu 23.04
FROM ubuntu:23.04@sha256:5ecfaeaaf7b0351f7ed301e389a13a6ff04f32f6e0e5e65f700b9321913b4497 AS ubuntu23.04-base

# Alma Linux 9.1
FROM almalinux:9.1-minimal@sha256:37d1d055ecc8f02a9142c82016712a797f3959da0c41c6ee93d7c2af8e0603dd AS almalinux9.1minimal-base

# Go 1.19 on Alpine 3.17
FROM golang:1.20.1-alpine3.17@sha256:48f336ef8366b9d6246293e3047259d0f614ee167db1869bdbc343d6e09aed8a AS golang1.19-base

# node:19-alpine3.17 
FROM node:19.6-alpine3.17@sha256:992dd138340c189b2bc49d879cc4b328b12b8aa3480a43b1a05505a18987df3b AS node19-base
