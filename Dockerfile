# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18.0
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 AS alpine3.18-base

# Ubuntu 23.04
FROM ubuntu:23.10@sha256:fc60884034bc6c05862dbcfd55875c6dccd0114ebdb908f56ea7645e978373db AS ubuntu23.04-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.2minimal-base

# Go 1.20 on Alpine 3.18
FROM golang:1.20.4-alpine3.18@sha256:ee2f23f1a612da71b8a4cd78fec827f1e67b0a8546a98d257cca441a4ddbebcb AS golang1.20-base

# node:19-alpine3.17 
FROM node:20.2-alpine3.17@sha256:4559bc033338938e54d0a3c2f0d7c3ad7d1d13c28c4c405b85c6b3a26f4ce5f7 AS node20-base
