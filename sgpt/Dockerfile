FROM python:3.15.0b2-slim-trixie@sha256:57d03f82306c37645b128f6474ea6459510670409965dbf7bd2a816876ccde87

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

