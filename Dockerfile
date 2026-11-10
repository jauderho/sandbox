# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 26.04
FROM ubuntu:26.04@sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c AS ubuntu-base

# Alma Linux 10.2
FROM almalinux:10.2-minimal@sha256:dfc4e05e3965fc933f9e256eb2e63a7a7a1eb1a53fa951c39841f2069ff38530 AS almalinux-base

# Alpine 3.24
FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS alpine-base

# Go 1.26 on Alpine 3.24
FROM golang:1.26.4-alpine3.22@sha256:727cfc3c40be55cd1bc9a4a059406b28a059857e3be752aa9d09531e12c20c56 AS golang-base

# Node 26 on Alpine 3.24
FROM node:26.13.0-alpine3.24@sha256:8996bb5821d62a8fd9bb27c1cb07462f3fdce6e47d640c6a881ead0b064ce216 AS node-base
