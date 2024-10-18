#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
FROM steamcmd/steamcmd:alpine-3@sha256:a1f18cd39bb2d8813b5cc7a51701fc3360ff48f0317b5959cbbc2436126cb04d

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
        && apk update \
        && apk add --no-cache ca-certificates wine
        
HEALTHCHECK NONE
