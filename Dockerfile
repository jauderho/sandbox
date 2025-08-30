# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Ubuntu 25.10
FROM ubuntu:25.10@sha256:1041699615b625b6bb6fbcdb7876bb1379f52b954374ab457360d9444a05cd7d AS ubuntu-base

# Alma Linux 10.0
FROM almalinux:10.0-minimal@sha256:52e453b8d40df644eb3af00ffffb63474e7aa70a0b62d0b4e43b019b4404d580 AS almalinux-base

# Alpine 3.22
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS alpine-base

# Go 1.24 on Alpine 3.22
FROM golang:1.25.0-alpine3.22@sha256:f18a072054848d87a8077455f0ac8a25886f2397f88bfdd222d6fafbb5bba440 AS golang-base

# Node 24 on Alpine 3.22
FROM node:24.7-alpine3.22@sha256:be4d5e92ac68483ec71440bf5934865b4b7fcb93588f17a24d411d15f0204e4f AS node-base
