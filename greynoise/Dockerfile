FROM ubuntu:25.10@sha256:fcdea13661343a0113773e1f3c481336462222a08993a9a83eae58268746d139
#FROM python:3.14.0rc1-alpine3.22@sha256:b0cfd0b2234c48a78d5ee6c7b082583a0c654317a6b0f03466db18ddd73b4fd6
#FROM python:3.14.0rc1-alpine3.22@sha256:b0cfd0b2234c48a78d5ee6c7b082583a0c654317a6b0f03466db18ddd73b4fd6

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
