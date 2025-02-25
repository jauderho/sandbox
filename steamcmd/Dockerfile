#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
FROM steamcmd/steamcmd:alpine-3@sha256:4b6c1e931a7ebb296507cb818f5a7a41c41803bb4d858938e218bd2357adad51

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
        && apk update \
        && apk add --no-cache ca-certificates wine
        
HEALTHCHECK NONE
