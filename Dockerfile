# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:4095ef613201918336b5d7d00be15d8b09c72ddb77c80bca249c255887a64d87 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:4f02be934419e0cc0b89f95be6463be8a7736eb75017f99ab66c9b0c59680cc6 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26rc2-alpine3.22@sha256:c03b7573b9514bb3f147104e02cf6680ba714f98fc603a38f460f7a590863417 AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.5-alpine3.22@sha256:7cda5d4400613ff7a4e9b2014bded8fa153871c32fd7ee12884c397c79bdcc93 AS node-base
