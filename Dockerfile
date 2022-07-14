# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.16.0
FROM alpine:3.16.0@sha256:686d8c9dfa6f3ccfc8230bc3178d23f84eeaf7e457f36f271ab1acc53015037c AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac AS ubuntu22.04-base

# Go 1.18 on Alpine 3.16
FROM golang:1.18.4-alpine3.16@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df AS golang1.18-base

# node:17-alpine3.15
#FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15

# node:18-alpine3.15 
FROM node:18-alpine3.15@sha256:5ad62659f793e0194c632cfdeeb9a5f052d241a648d2cfba56f8c05497bf5b5f AS node18-alpine3.15
