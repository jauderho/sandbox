# This is a dummy Dockerfile only used for tracking container digest to version mappings
USER nobody
HEALTHCHECK echo

# Alpine 3.20
FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099 AS alpine3.21-base

# Ubuntu 24.10
FROM ubuntu:25.04@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb AS ubuntu25.04-base

# Alma Linux 9.4
FROM almalinux:9.5-minimal@sha256:8ecd8d4dc786dd4aa88e4c7cc1b7c2456288e600e1d53986dd21d1b118547a3c AS almalinux9.5minimal-base

# Go 1.23 on Alpine 3.20
FROM golang:1.23.5-alpine3.20@sha256:def59a601e724ddac5139d447e8e9f7d0aeec25db287a9ee1615134bcda266e2 AS golang1.23-base

# Node 22 on Alpine 3.20 
FROM node:23.6-alpine3.20@sha256:f4ab7927786d95893eb4f21325ebbee813fa9229cb636ee2728f7120e1b7730a AS node23-base

