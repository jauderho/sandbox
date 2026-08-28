FROM almalinux:10.2-minimal@sha256:bafd259fb7b0475eed28376ddddea19f209e24efafc9eb21f4e9d5ed9825d2ef
# FROM rockylinux:9.3-minimal@sha256:305de618a5681ff75b1d608fd22b10f362867dff2f550a4f1d427d21cd7f42b4

# Dell gives each release its own opaque dl.dell.com folder id, and there is no
# way to derive one from the version - always bump FOLDER_VERSION and
# BUILD_VERSION together. Known pairs:
#
#   FOLDER12722122M  4.1.0.0.1338
#   FOLDER13576510M  4.2.0.0.1553
#   FOLDER13877768M  4.3.0.0.1661
#
# Find the current pair on the Dell driver page for "PowerStore Command Line
# Interface (CLI) tool for Linux x64":
#   https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=nntwn
ARG BUILD_VERSION=4.3.0.0.1661
ARG FOLDER_VERSION=FOLDER13877768M
ARG ARCHIVE_URL=https://dl.dell.com/${FOLDER_VERSION}/1/pstcli-${BUILD_VERSION}.x86_64.release.rpm

#COPY pstcli-${BUILD_VERSION}.x86_64.release.rpm .

# dl.dell.com rejects a default curl user-agent with an Akamai "Access Denied"
# page, so pretend to be a browser. -f makes curl fail loudly rather than saving
# that HTML and handing it to rpm.
RUN test -n "${BUILD_VERSION}" \
  && microdnf -y upgrade --refresh \
  && microdnf -y install libxcrypt-compat \
  && curl --proto '=https' --proto-redir '=https' "${ARCHIVE_URL}" -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36' -fLso pstcli-${BUILD_VERSION}.x86_64.release.rpm \
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

