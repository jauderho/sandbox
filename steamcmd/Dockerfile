#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
FROM steamcmd/steamcmd:alpine-3@sha256:bc9534fb906a680e40305bcf74f66c5e0475ee386725681791700393a6133514

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
        && apk update \
        && apk add --no-cache ca-certificates wine
        
HEALTHCHECK NONE
