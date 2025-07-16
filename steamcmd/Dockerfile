#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
FROM steamcmd/steamcmd:alpine-3@sha256:b22e124b475a7624e5923416abffb2f17748636f6aa529b2671a0ed1271ef43c

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
        && apk update \
        && apk add --no-cache ca-certificates wine
        
HEALTHCHECK NONE
