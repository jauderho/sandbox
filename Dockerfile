# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:8abf9cea172b86fe77d65ef1abbdb186d06d1b44858efe09a16de7e2c43f645a AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21rc2-alpine3.18@sha256:6950b1dd68ad2bac952e9c702f820053ea6a23757c4dd9b258edb3137e542524 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.4-alpine3.18@sha256:8165161b6e06ec092cf5d02731e8559677644845567dbe41b814086defc8c261 AS node20-base
