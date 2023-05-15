# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.17.0
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 AS alpine3.17-base

# Ubuntu 23.04
FROM ubuntu:23.04@sha256:db2764b64a490a9ce44a7ce0c7ba7cc6d0472c8c44684960dbca7a06525eb597 AS ubuntu23.04-base

# Alma Linux 9.1
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.1minimal-base

# Go 1.20 on Alpine 3.17
FROM golang:1.20.4-alpine3.17@sha256:913de96707b0460bcfdfe422796bb6e559fc300f6c53286777805a9a3010a5ea AS golang1.20-base

# node:19-alpine3.17 
FROM node:20.1-alpine3.17@sha256:6e56967f8a4032f084856bad4185088711d25b2c2c705af84f57a522c84d123b AS node19-base
