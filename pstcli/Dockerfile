FROM almalinux:9.3-minimal@sha256:980a7a662a9aebb0c177376327a2dd88b7eefec2f8e8fcd0999421d6e9818d2c
# FROM rockylinux:9.1-minimal@sha256:9f700bae74355a24f30a7715aeb70d3605746c51776f5ce26486a5ec27243666

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://dl.dell.com/FOLDER11395572M/1/pstcli-${BUILD_VERSION}.x86_64.release.rpm

# https://dl.dell.com/FOLDER11395572M/1/pstcli-3.6.1.0.1084.x86_64.release.rpm

COPY pstcli-3.6.1.0.1084.x86_64.release.rpm .

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

