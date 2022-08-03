# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.16.0
FROM alpine:3.16.1@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872 AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:34fea4f31bf187bc915536831fd0afc9d214755bf700b5cdb1336c82516d154e AS ubuntu22.04-base

# Go 1.18 on Alpine 3.16
FROM golang:1.19.0-alpine3.16@sha256:f734a85923ff49da7caf82940b422bf679ca9bdec38cc56f501a4745b557d150 AS golang1.18-base

# node:17-alpine3.15
#FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15

# node:18-alpine3.15 
FROM node:18-alpine3.15@sha256:fd83c1f4e4f1bee2f29978b89549b3127daac92cb889914aa7cc7b1aa0fc7b90 AS node18-alpine3.15
