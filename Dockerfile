# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.15.4
FROM alpine:3.15.4@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 AS alpine3.15-base

# Ubuntu 20.04
#FROM ubuntu:20.04@sha256:bea6d19168bbfd6af8d77c2cc3c572114eb5d113e6f422573c93cb605a0e2ffb AS ubuntu20.04-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:06b5d30fabc1fc574f2ecab87375692299d45f8f190d9b71f512deb494114e1f AS ubuntu22.04-base

# Go 1.18 on Alpine 3.15
FROM golang:1.18.1-alpine3.15@sha256:42d35674864fbb577594b60b84ddfba1be52b4d4298c961b46ba95e9fb4712e8 AS golang1.18-base

# node:16-alpine3.15 
FROM node:18-alpine3.15@sha256:469ee26d9e00547ea91202a34ff2542f984c2c60a2edbb4007558ccb76b56df2 AS node16-alpine3.15

# node:17-alpine3.15
FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15
