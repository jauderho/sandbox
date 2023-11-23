FROM almalinux:9.3-minimal@sha256:978a910978a82d4e4bca9eb7e711065cc8535d2446f79f0caf41a2e539f56eac
# FROM rockylinux:9.1-minimal@sha256:9f700bae74355a24f30a7715aeb70d3605746c51776f5ce26486a5ec27243666

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://dl.dell.com/protected/drivers/FOLDER10048546M/1/pstcli-${BUILD_VERSION}.x86_64.release.rpm

# https://dl.dell.com/protected/drivers/FOLDER10048546M/1/pstcli-3.5.0.0.891.x86_64.release.rpm

COPY pstcli-3.5.0.0.891.x86_64.release.rpm .

RUN test -n "${BUILD_VERSION}" \
  && microdnf -y upgrade --refresh \ 
  && microdnf -y install libxcrypt-compat \ 
  #&& curl -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36' -Lo pstcli-${BUILD_VERSION}.x86_64.release.rpm "${ARCHIVE_URL}" \
  #&& rpm -i pstcli-${BUILD_VERSION}.x86_64.release.rpm \
  && rpm -i pstcli-${BUILD_VERSION}.x86_64.release.rpm 
  #&& rm -rf pstcli-${BUILD_VERSION}.x86_64.release.rpm \ 
  #&& microdnf clean all

# EXPOSE
# ENV
# STOPSIGNAL
HEALTHCHECK NONE
USER nobody

#ENTRYPOINT ["pstcli"]
CMD ["pstcli"]

