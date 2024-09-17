FROM ubuntu:24.10@sha256:67541378af7d535606e684a8234d56ca0725b6a4d8b0bbf19cebefed98e06f42
#FROM python:3.13.0rc2-alpine3.20@sha256:91db060265f65eeb7a2fb2fbe18a5790ec64c01d0cb57ba2272120fc4de3ce94
#FROM python:3.13.0rc2-alpine3.20@sha256:91db060265f65eeb7a2fb2fbe18a5790ec64c01d0cb57ba2272120fc4de3ce94

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
