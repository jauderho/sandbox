# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.18.0
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 AS alpine3.18-base

# Ubuntu 23.04
FROM ubuntu:23.10@sha256:2cde79b4627d38d1448fc264f93e465f18b653bc9a62ee8ec85d99d4e8f39d4c AS ubuntu23.10-base

# Alma Linux 9.2
FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23 AS almalinux9.2minimal-base

# Go 1.20 on Alpine 3.18
FROM golang:1.20.5-alpine3.18@sha256:b036c52b3bcc8e4e31be19a7a902bb9897b2bf18028f40fd306a9778bab5771c AS golang1.20-base

# node:20-alpine3.18 
FROM node:20.3-alpine3.18@sha256:30d5045fa5026abaed7439b62d51f73ac3efd1009496271d4c85fd83bb20144e AS node20-base
