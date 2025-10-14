# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:9b61739164b58f2263067bd3ab31c7746ded4cade1f9d708e6f1b047b408a470 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:cd55007b9804e36134bf488df6437171615c7a318addb13dd762375b39ef5629 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.3-alpine3.22@sha256:20ee0b674f987514ae3afb295b6a2a4e5fa11de8cc53a289343bbdab59b0df59 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.10-alpine3.22@sha256:6ff78d6d45f2614fe0da54756b44a7c529a15ebcaf9832fab8df036b1d466e73 AS node-base
