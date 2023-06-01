FROM almalinux:9.2-minimal@sha256:0bb374219d5a2e677cbf6f1a74d5cb3b8f827da305f0daadc0cad5ad0915eb23
# FROM rockylinux:9.1-minimal@sha256:9f700bae74355a24f30a7715aeb70d3605746c51776f5ce26486a5ec27243666

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://dl.dell.com/FOLDER08713913M/1/pstcli-${BUILD_VERSION}.x86_64.release.rpm

RUN test -n "${BUILD_VERSION}" \
  && microdnf -y upgrade --refresh \ 
  && microdnf -y install wget libxcrypt-compat \ 
  && wget "${ARCHIVE_URL}" \
  && rpm -i pstcli-${BUILD_VERSION}.x86_64.release.rpm \
  && rm -rf pstcli-${BUILD_VERSION}.x86_64.release.rpm \ 
  && microdnf -y remove wget \ 
  && microdnf clean all

# EXPOSE
# ENV
# STOPSIGNAL
HEALTHCHECK NONE
USER nobody

ENTRYPOINT ["pstcli"]
