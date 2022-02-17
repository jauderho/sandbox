# This is a dummy Dockerfile only used for tracking container digest to version mappings

# Alpine 3.14.3
FROM alpine:3.14.3@sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2 AS alpine3.14-base

# Alpine 3.15.0
FROM alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300 AS alpine3.15-base

# Ubuntu 20.04
FROM ubuntu:20.04@sha256:669e010b58baf5beb2836b253c1fd5768333f0d1dbcb834f7c07a4dc93f474be AS ubuntu20.04-base

# Ubuntu 21.10
FROM ubuntu:21.10@sha256:1108598c6469492b0ec61c4c9bab6868a3d335ecf76deb4d31ff3b2615170ae9 AS ubuntu21.10-base

# Ubuntu 22.04
FROM ubuntu:22.04@sha256:a02c32cf0c2a7e8743c74deef66637aa70e063c9bd40e9e1f8c0b3ea0750b0ba AS ubuntu22.04-base

# Go 1.17.7 on Alpine 3.15
FROM golang:1.17.7-alpine3.15@sha256:c23027af83ff27f663d7983750a9a08f442adb2e7563250787b23ab3b6750d9e AS golang1.17.7-base

# Go 1.18-rc on Alpine 3.15
FROM golang:1.18-rc-alpine3.15@sha256:c39ab37dfa0810a3f1c9fb4a0e7b947af55dbe1edc77c0e167a96b290d8f5efa AS golang1.18-rc-base

# node:16-alpine3.15 
FROM node:16-alpine3.15@sha256:2f50f4a428f8b5280817c9d4d896dbee03f072e93f4e0c70b90cc84bd1fcfe0d AS node16-alpine3.15

# node:17-alpine3.15
FROM node:17-alpine3.15@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2 AS node17-alpine3.15
