#FROM almalinux:9.1
FROM almalinux:9.1-minimal@sha256:565f87aeb5da6481e497788347cd57ebf5b19df42ac5a67a5bdf4d044ddb9a69
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
