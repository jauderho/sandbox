FROM ubuntu:23.10@sha256:2c12b887bd41265d2a3a5e993060c9da28dfc7eaab138c908aec196e087a3c86
#FROM python:3.11.4-alpine3.18@sha256:bd16cc548687f25bf7cbc29c3d284c290cf63899b281f0f3a52fc697b48884c7
#FROM python:3.11.4-alpine3.18@sha256:bd16cc548687f25bf7cbc29c3d284c290cf63899b281f0f3a52fc697b48884c7

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt . 

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends python3-pip && \
	python3 -m pip install --no-cache-dir --upgrade pip --break-system-packages && \
	pip3 install --no-cache-dir -r requirements.txt --break-system-packages && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

#	apt-get purge -y python3-dev && \
#RUN pip install sslyze==${BUILD_VERSION}
#RUN pip3 install --no-cache-dir -r requirements.txt

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/greynoise"
LABEL org.opencontainers.image.description="GreyNoise is the sources for understanding internet noise"

ENTRYPOINT ["greynoise"]
CMD ["-h"]
