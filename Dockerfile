# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:10b61aabaaf0123f3670112057c3b3ccf27c808ddb892ba5a4e32366bff7f3fe AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:b8aac66632e6dc553571fa49f39c975b54c10837439eb3943ea64b1e607fd01d AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.24.4-alpine3.22@sha256:68932fa6d4d4059845c8f40ad7e654e626f3ebd3706eef7846f319293ab5cb7a AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.3-alpine3.22@sha256:b8ea75e6dcdf7dbba1ea8b57f77ec89ef04c1719d2ae986c8fbea21f9f4ec187 AS node-base
