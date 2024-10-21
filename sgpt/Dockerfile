FROM python:3.13.0-slim-bookworm@sha256:751d8bece269ba9e672b3f2226050e7e6fb3f3da3408b5dcb5d415a054fcb061

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_ROOT_USER_ACTION ignore
WORKDIR /app
COPY . /app

RUN pip install --no-cache --upgrade pip \
 && pip install --no-cache /app \
 && addgroup --system app && adduser --system --group app \
 && mkdir -p /home/app/.config/shell-gpt \
 && echo "api_key.txt should be here" > /home/app/.config/shell-gpt/readme.txt \
 && chown -R app:app /home/app

USER app

VOLUME /home/app/.config/shell-gpt
ENTRYPOINT ["/usr/local/bin/sgpt"]

