# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.21
FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS alpine3.21-base

# Ubuntu 25.04
FROM ubuntu:25.04@sha256:79efa276fdefa2ee3911db29b0608f8c0561c347ec3f4d4139980d43b168d991 AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:9d3e33caf50a138f24b49f45dc463720c628444ed46e19feb902cc63c417e957 AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.21
FROM golang:1.24.3-alpine3.21@sha256:ef18ee7117463ac1055f5a370ed18b8750f01589f13ea0b48642f5792b234044 AS golang1.24-base

# Node 23 on Alpine 3.21 
FROM node:24.0-alpine3.21@sha256:7804c7734b3e0cf647ab8273a1d4cda776123145da5952732f3dca9e742ddca0 AS node23-base

