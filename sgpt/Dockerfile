FROM python:3.15.0b1-slim-trixie@sha256:628d63535bf48bb15d9fe86f09e3c4b58817094122dccc7b202e2d9bfeca0e7f

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_ROOT_USER_ACTION=ignore
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

