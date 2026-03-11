FROM python:3.15.0a7-slim-trixie@sha256:8b751209a52007829954555954e3be395e07ab7332aa828ca8d4f01d7558fa50

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

