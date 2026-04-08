# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:cc925e589b7543b910fea57a240468940003fbfc0515245a495dd0ad8fe7cef1 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:747f062616f496b0630277a9f25ce9a4d25986887ad6d6dad05cfc6f8b274d90 AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:07e91d24f6330432729082bb580983181809e0a48f0f38ecde26868d4568c6ac AS golang-base

# Node 24 on Alpine 3.22
FROM node:25.9.0-alpine3.22@sha256:45ee7adabf5073b70c18746ef34be804077b8f5fa09d0188c19697590463b53e AS node-base
