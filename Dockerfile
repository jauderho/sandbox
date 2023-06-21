# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18.0
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS alpine3.18-base

# Ubuntu 23.04
FROM ubuntu:23.10@sha256:bd1e0eb3171a6e499c84211e73c4f5f5b2a585507256f772f5c4f4420a3d8591 AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.2minimal-base

# Go 1.20 on Alpine 3.18
FROM golang:1.20.5-alpine3.18@sha256:fd9d9d7194ec40a9a6ae89fcaef3e47c47de7746dd5848ab5343695dbbd09f8c AS golang1.20-base

# node:20-alpine3.18 
FROM node:20.3-alpine3.18@sha256:f935f3dfb84f48abed50efe5fbf87b955d5ee864c0ec69e307e5ee0e1a52e4ea AS node20-base
