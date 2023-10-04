# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:282510723f2be541c2facce0f7e918641bedd90936f8a76f6f38b7110e299d5c AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.1-alpine3.18@sha256:1c9cc949513477766da12bfa80541c4f24957323b0ee00630a6ff4ccf334b75b AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.8-alpine3.18@sha256:37750e51d61bef92165b2e29a77da4277ba0777258446b7a9c99511f119db096 AS node20-base
