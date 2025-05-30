# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:36bbb8adc0662496d3e314bc8a25cb41c0c2e42ed25daaa07f8369d36d16f082 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:ae1b7fe96fd267d82e34a7086149177e2cc8192519515f27f39e9463a9b79eb7 AS almalinux-base

# Go 1.24 on Alpine 3.21
FROM golang:1.24.3-alpine3.21@sha256:ef18ee7117463ac1055f5a370ed18b8750f01589f13ea0b48642f5792b234044 AS golang-base

# Node 24 on Alpine 3.21 
FROM node:24.1-alpine3.21@sha256:dfea0736e82fef246aba86b2082a5e86c4825470302692b841d097dd61253b79 AS node-base

