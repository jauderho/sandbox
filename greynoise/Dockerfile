FROM ubuntu:25.10@sha256:dd397d3b5e4896054db111cb5145c0c08a6e7a669537e750e79e0385f2d69207
#FROM python:3.14.0b2-alpine3.22@sha256:371485ef9694c129864ddaf84cc0d97258060c87cf38e20f03b4d1f64141c24b
#FROM python:3.14.0b2-alpine3.22@sha256:371485ef9694c129864ddaf84cc0d97258060c87cf38e20f03b4d1f64141c24b

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
