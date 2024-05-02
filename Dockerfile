# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:3f85b7caad41a95462cf5b787d8a04604c8262cdcdf9a472b8c52ef83375fe15 AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:980a7a662a9aebb0c177376327a2dd88b7eefec2f8e8fcd0999421d6e9818d2c AS almalinux9.3minimal-base

# Go 1.22 on Alpine 3.19
FROM golang:1.22.2-alpine3.19@sha256:cdc86d9f363e8786845bea2040312b4efa321b828acdeb26f393faa864d887b0 AS golang1.22-base

# node:21-alpine3.18 
FROM node:22.0-alpine3.19@sha256:9459e243f620fff19380c51497493e91db1454f5a30847efe5bc5e50920748d5 AS node21-base
