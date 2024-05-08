# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:562456a05a0dbd62a671c1854868862a4687bf979a96d48ae8e766642cd911e8 AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:980a7a662a9aebb0c177376327a2dd88b7eefec2f8e8fcd0999421d6e9818d2c AS almalinux9.3minimal-base

# Go 1.22 on Alpine 3.19
FROM golang:1.22.3-alpine3.19@sha256:2a882244fb51835ebbd8313bffee83775b0c076aaf56b497b43d8a4c72db65e1 AS golang1.22-base

# node:21-alpine3.18 
FROM node:22.1-alpine3.19@sha256:487dc5d5122d578e13f2231aa4ac0f63068becd921099c4c677c850df93bede8 AS node21-base
