# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:bd1e0eb3171a6e499c84211e73c4f5f5b2a585507256f772f5c4f4420a3d8591 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21rc2-alpine3.18@sha256:e046e58e1fb252b81b5363f49d70780ad66bbb29a4a6c23197dcd36e37619aa0 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.3-alpine3.18@sha256:f77f29bc47124b393d8e7ae947be385e851d7c448d85ab87a4c077af84ee8ea2 AS node20-base
