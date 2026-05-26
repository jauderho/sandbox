# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:26.04@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64 AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.1-minimal@sha256:6836d8e266ef3911e483951556a2cd01cc8e86bab7d1eb1b040682d61393dbee AS almalinux-base

# Alpine 3.22
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.26-alpine3.22@sha256:be93003ee861b3b91b6ebcb22678524947e0cd786c2df3f32af520006b1e54f5 AS golang-base

# Node 24 on Alpine 3.22
FROM node:26.2.0-alpine3.22@sha256:56392f8949e007103b800098434f993924ea714bf2b1f84056e68c61d720e26c AS node-base
