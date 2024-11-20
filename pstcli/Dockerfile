FROM almalinux:9.5-minimal@sha256:8ecd8d4dc786dd4aa88e4c7cc1b7c2456288e600e1d53986dd21d1b118547a3c
# FROM rockylinux:9.3-minimal@sha256:305de618a5681ff75b1d608fd22b10f362867dff2f550a4f1d427d21cd7f42b4

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://dl.dell.com/FOLDER12078845M/1/pstcli-${BUILD_VERSION}.x86_64.release.rpm

# https://dl.dell.com/FOLDER11395572M/1/pstcli-3.6.1.0.1084.x86_64.release.rpm
# https://dl.dell.com/FOLDER12078845M/1/pstcli-4.0.0.2.1245.x86_64.release.rpm

#COPY pstcli-${BUILD_VERSION}.x86_64.release.rpm .

RUN test -n "${BUILD_VERSION}" \
  && microdnf -y upgrade --refresh \ 
  && microdnf -y install libxcrypt-compat \ 
  && curl "${ARCHIVE_URL}" -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36' -Lso pstcli-${BUILD_VERSION}.x86_64.release.rpm \
  && rpm -i pstcli-${BUILD_VERSION}.x86_64.release.rpm \
  && rm -rf pstcli-${BUILD_VERSION}.x86_64.release.rpm \ 
  && microdnf -y clean all
  #&& rpm -i pstcli-${BUILD_VERSION}.x86_64.release.rpm 

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/pstcli"
LABEL org.opencontainers.image.description="CLI for PowerStore"

# EXPOSE
# ENV
# STOPSIGNAL
HEALTHCHECK NONE
USER nobody

ENTRYPOINT ["pstcli"]
#CMD ["pstcli"]

