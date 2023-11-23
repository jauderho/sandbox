# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18
FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 AS alpine3.18-base

# Ubuntu 23.10
FROM ubuntu:23.10@sha256:4c32aacd0f7d1d3a29e82bee76f892ba9bb6a63f17f9327ca0d97c3d39b9b0ee AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.3-minimal@sha256:978a910978a82d4e4bca9eb7e711065cc8535d2446f79f0caf41a2e539f56eac AS almalinux9.2minimal-base

# Go 1.21 on Alpine 3.18
FROM golang:1.21.4-alpine3.18@sha256:110b07af87238fbdc5f1df52b00927cf58ce3de358eeeb1854f10a8b5e5e1411 AS golang1.21-base

# node:20-alpine3.18 
FROM node:21.2-alpine3.18@sha256:4a512d1538b1a8281b58cab0b366a5c62436566bb63e7dcd4a6769c98edb3b5f AS node20-base
