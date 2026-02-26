# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:fed6ddb82c61194e1814e93b59cfcb6759e5aa33c4e41bb3782313c2386ed6df AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:7e4fd6b1a34ef63762ff03a48cefad1e5ca8660c18d1dc850023d44fde73587c AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:169d3991a4f795124a88b33c73549955a3d856e26e8504b5530c30bd245f9f1b AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.7.0-alpine3.22@sha256:b18a0d1f15ab7cc704aee3ad04b510b10781afc67818fbf1936ff4635cd71a23 AS node-base
