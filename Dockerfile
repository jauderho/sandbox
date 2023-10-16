# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:4c32aacd0f7d1d3a29e82bee76f892ba9bb6a63f17f9327ca0d97c3d39b9b0ee AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0240ad1be8c11dda3af295a293e619f9bafcd6041f21c1123c6b5f2698298e49 AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.3-alpine3.18@sha256:926f7f7e1ab8509b4e91d5ec6d5916ebb45155b0c8920291ba9f361d65385806 AS golang1.21-base

# node:20-alpine3.18 
FROM node:20.8-alpine3.18@sha256:fe6d1d50ed869c550be95ca6448cd59d3695f28b9fef24e784a129e1ed869795 AS node20-base
