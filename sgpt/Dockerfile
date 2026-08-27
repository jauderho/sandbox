# 3.15 is still beta and jiter publishes no cp315 wheel, so pydantic-core and
# jiter both fell back to a cargo build. 3.14 has wheels for everything.
#FROM python:3.15.0b3-slim-trixie@sha256:a13b3ba393211ef88d09ca75de22e9b8412a98713f7cf8ca7274fc61d34799a6
FROM python:3.14-slim-trixie@sha256:cae66f2ef0ec51a9891263eeee7f987dacf0a9879e8aa9353d5606e0530619a5

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_ROOT_USER_ACTION=ignore
WORKDIR /app
COPY . /app

# shell_gpt is pulled straight from git, so git has to be present at install time
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
 && pip install --no-cache --upgrade pip \
 && pip install --no-cache /app \
 && apt-get purge -y git \
 && apt-get autoremove -y --purge \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && addgroup --system app && adduser --system --group app \
 && mkdir -p /home/app/.config/shell-gpt \
 && echo "api_key.txt should be here" > /home/app/.config/shell-gpt/readme.txt \
 && chown -R app:app /home/app

USER app

VOLUME /home/app/.config/shell-gpt
ENTRYPOINT ["/usr/local/bin/sgpt"]

