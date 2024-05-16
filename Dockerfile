# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.19
FROM alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b AS alpine3.19-base

# Ubuntu 24.04
FROM ubuntu:24.04@sha256:562456a05a0dbd62a671c1854868862a4687bf979a96d48ae8e766642cd911e8 AS ubuntu24.04-base

# Alma Linux 9.3
FROM almalinux:9.4-minimal@sha256:7b061ba0f4d69efe44565d12974f9032b4ee48dbc9cbcf27973f134158771a3d AS almalinux9.3minimal-base

# Go 1.22 on Alpine 3.19
FROM golang:1.22.3-alpine3.19@sha256:f1fe698725f6ed14eb944dc587591f134632ed47fc0732ec27c7642adbe90618 AS golang1.22-base

# node:21-alpine3.18 
FROM node:22.2-alpine3.19@sha256:9e8f45fc08c709b1fd87baeeed487977f57585f85f3838c01747602cd85a64bb AS node21-base
