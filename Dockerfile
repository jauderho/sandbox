# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:5b582c80ed6832665ffb6181ab4d3e5e70c30c2548fbcea1de8a0a51f161be8d AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.3-minimal@sha256:980a7a662a9aebb0c177376327a2dd88b7eefec2f8e8fcd0999421d6e9818d2c AS almalinux9.3minimal-base

# Go 1.22 on Alpine 3.19
FROM golang:1.22.2-alpine3.19@sha256:cdc86d9f363e8786845bea2040312b4efa321b828acdeb26f393faa864d887b0 AS golang1.22-base

# node:21-alpine3.18 
FROM node:22.0-alpine3.19@sha256:68d426074f205de1678bcbb6e43f5f4699b2e6e6e3ac50e0aa1a91daabd35602 AS node21-base
