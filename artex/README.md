[![Build Status](https://github.com/jauderho/sandbox/workflows/artex/badge.svg)](https://github.com/jauderho/sandbox/actions)

ARTEX ([BaaRai/ARTEX](https://github.com/BaaRai/ARTEX)) is an AI autonomous penetration testing system. This image is built from source on Ubuntu, with Python 3.14 managed by uv and the frontend and JavaScript packages installed with bun. It bundles nuclei, httpx, subfinder, katana, ffuf, dalfox, sqlmap, nmap, legba, bbot and Playwright MCP/CLI with Chromium.

Usage:

```
docker run -d --name artex -p 8787:8787 -p 8788:8788 \
  -v artex-data:/app/data -v artex-keys:/app/keys \
  ghcr.io/jauderho/artex:latest
```

- 8787: web UI / API
- 8788: intercepting proxy

ARTEX needs PostgreSQL (`ARTEX_PG_DSN`); see upstream's `docker-compose.yml`.

Notes:

- ARTEX runs as root inside the container because it drops agent processes to a separate executor uid (10001 by default) itself.
- bbot's tools and dependencies are preinstalled only for the modules ARTEX's `bbot-recon` skill uses, under `/opt/bbot-home`, so they are visible to the executor uid. Scans must run with `--no-deps`, as the skill requires.
- Playwright MCP, playwright-cli and the Playwright test runner all use `playwright` 1.64.1 (an override of MCP/CLI's prerelease pin), so the image carries one Chromium revision where upstream carries two. Its `/usr/bin/chromium` is that Chromium.
- `@playwright/test` and `puppeteer-core` (used by api-recon's runtime harvester) are preinstalled and resolve through `NODE_PATH`, with no npm install needed.
- bbot's `portscan` module needs root (masscan via sudo) and is unavailable to the executor, as in upstream's image.

Only use it against targets you are authorized to test. Images: linux/amd64, linux/arm64.
