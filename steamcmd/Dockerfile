#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
FROM steamcmd/steamcmd:alpine-3@sha256:4137fa9890396549c406ab65a57bdb3a2b98e6fae7bd0a5c63d914a03190c918

ARG BUILD_VERSION

RUN test -n "${BUILD_VERSION}" \
        && apk update \
        && apk add --no-cache ca-certificates wine
        
HEALTHCHECK NONE
