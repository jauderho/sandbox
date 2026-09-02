FROM ghcr.io/astral-sh/uv:0.12.9@sha256:8b940d3a9d65bed080436972241af2e21c84b5e8c9193f7014ed71479ee795ff AS uv


# --------------------------------------------------------------------------


# 3.15 is still beta and jiter publishes no cp315 wheel, so pydantic-core and
# jiter both fell back to a cargo build. 3.14 has wheels for everything.
#FROM python:3.15.0b3-slim-trixie@sha256:a13b3ba393211ef88d09ca75de22e9b8412a98713f7cf8ca7274fc61d34799a6
FROM python:3.14-slim-trixie@sha256:cad9a2c871761c413caa6fdd6441c783451e740a48aaeba60ae62a8b53525ef6

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY . /app

# shell_gpt is pulled straight from git, so git has to be present at install time
# uv is bind mounted rather than copied in, so its ~35MB never lands in a layer
RUN --mount=from=uv,source=/uv,target=/usr/local/bin/uv \
    apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git \
 && uv pip install --system --no-cache /app \
 && apt-get purge -y git \
 && apt-get autoremove -y --purge \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && addgroup --system app \
 && adduser --system --group --home /home/app app \
 && mkdir -p /home/app/.config/shell_gpt \
 && echo "sgpt keeps its settings in .sgptrc here. Pass the key as OPENAI_API_KEY." \
      > /home/app/.config/shell_gpt/readme.txt \
 && chown -R app:app /home/app

USER app

# adduser --system defaults the home directory to /nonexistent, so sgpt used to
# die trying to create $HOME/.config/shell_gpt. The folder name is shell_gpt
# with an underscore, which is what sgpt/config.py builds its path from.
ENV HOME=/home/app

# shell_gpt writes .sgptrc on its first run, but that same first run then fails:
# Config.get() reports DEFAULT_TEMPERATURE as missing because its default is the
# float 0.0, which is falsy. It only works once the value has been read back from
# the file as the string "0.0". So seed the config here and let the second run be
# the smoke test. OPENAI_API_KEY only suppresses the interactive key prompt; it
# is not part of DEFAULT_CONFIG and is never written to .sgptrc.
RUN OPENAI_API_KEY=seed sgpt --version > /dev/null 2>&1; \
    OPENAI_API_KEY=seed sgpt --version

VOLUME /home/app/.config/shell_gpt
ENTRYPOINT ["/usr/local/bin/sgpt"]

