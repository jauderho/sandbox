FROM ubuntu:25.04@sha256:79efa276fdefa2ee3911db29b0608f8c0561c347ec3f4d4139980d43b168d991

WORKDIR /ansible

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

#ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# requirements.txt now generated from Pipfile
# pipenv lock -r > requirements.txt
COPY requirements.txt .

RUN apt-get update && \
	DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get install -y --no-install-recommends cargo gcc libkrb5-dev libssl-dev python3-dev python3-pip sshpass git openssh-client gnupg2 && \
	pip3 install --no-cache-dir -r requirements.txt && \
	apt-get purge -y cargo gcc libkrb5-dev libssl-dev python3-dev && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

#RUN pip3 install --no-cache-dir -r requirements.txt

#RUN python3 -m pip install --upgrade pip && \
#    pip3 install ansible==${BUILD_VERSION} && \
#    pip3 install ansible-lint jmespath && \
#    pip3 install pywinrm[kerberos,credssp] && \
#    rm -rf /root/.cache/pip

#RUN pip3 freeze > requirements.txt && cat requirements.txt

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/ansible"
LABEL org.opencontainers.image.description="Ansible is a radically simple IT automation platform"

RUN mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

HEALTHCHECK NONE

CMD [ "ansible-playbook", "--version" ]
