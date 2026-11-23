#!/usr/bin/docker build .
#
# ARTEX - AI autonomous penetration testing system
# https://github.com/BaaRai/ARTEX
#
# Adapted from upstream's Dockerfile: same stages and the same pinned toolbox,
# rebuilt on ubuntu + uv (Python 3.14) + bun instead of debian + pip + npm.
# Every version is passed in from .github/workflows/artex.yml; none default here.
#
#   src (git clone) -> web (bun) -> build (Go, embedded UI)
#   tools (recon binaries)  python (uv: CPython + bbot venv)
#   playwright (bun: MCP/CLI + Chromium)                     -> runtime
#
# Everything is assembled in builder stages; the runtime stage only copies
# results in and installs system packages. uv and bun are bind-mounted where
# used and never land in a layer.

# ---------------------------------------------------------------------------
# uv and bun publish linux/amd64 and linux/arm64 only, which caps this image
# at those two platforms.
# ---------------------------------------------------------------------------
FROM ghcr.io/astral-sh/uv:0.13.9@sha256:d3b601f0c7b118bc1753febf7c41cc80981df678445e0254284eecf84db79a7d AS uv

FROM oven/bun:1.4.5@sha256:3aa040e5445efa09d75bb428a64ba50db13e2b3ac9b6b0c7f145615f62b2ee18 AS bun


# ----------------------------------------------------------------------------
# Source: one shallow clone of the pinned tag, shared by the web and Go stages.
# ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM ghcr.io/jauderho/golang:1.27.4-alpine3.24@sha256:3639a8b3e4cc482b070661c2b0e342ed633fd4a982c083b92738f168d9a9b273 AS src

ARG BUILD_VERSION
ARG GIT_URL=https://github.com/BaaRai/ARTEX.git

RUN test -n "${BUILD_VERSION}" \
	&& apk add --no-cache git \
	&& git clone --depth 1 --branch "${BUILD_VERSION}" "${GIT_URL}" /src \
	&& rm -rf /src/.git


# ----------------------------------------------------------------------------
# Frontend: Next.js static export, built with bun in place of npm. The export
# is architecture-independent, so this runs on the build platform only.
# ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM oven/bun:1.4.5@sha256:3aa040e5445efa09d75bb428a64ba50db13e2b3ac9b6b0c7f145615f62b2ee18 AS web

ENV NEXT_TELEMETRY_DISABLED=1

COPY --from=src /src/web /src/web
WORKDIR /src/web

# No bun.lock upstream: bun migrates package-lock.json, so the resolved
# versions stay the ones upstream locked. --ignore-scripts skips husky.
RUN bun install --ignore-scripts \
	&& NEXT_EXPORT=1 bun --bun x next build \
	&& test -f out/index.html


# ----------------------------------------------------------------------------
# Go binary with the UI embedded (-tags embedui), same flags as upstream's
# build.sh. CGO-free, so it cross-compiles to $TARGETARCH without QEMU.
# ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM ghcr.io/jauderho/golang:1.27.4-alpine3.24@sha256:3639a8b3e4cc482b070661c2b0e342ed633fd4a982c083b92738f168d9a9b273 AS build

ARG BUILD_VERSION
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

COPY --from=src /src /src
COPY --from=web /src/web/out /src/server/webui/dist
WORKDIR /src

RUN go build -v -tags embedui -trimpath \
		-ldflags "-s -w -buildid= -X main.version=${BUILD_VERSION#v}" \
		-o /out/artex ./cmd/artex \
	&& go clean -cache -modcache


# ----------------------------------------------------------------------------
# Web-recon toolbox: release binaries checked against SHA-256 digests pinned
# in the workflow (not against each release's own checksums file, which comes
# from the same publisher as the asset). sqlmap is a shallow clone of a pinned
# tag, checked against the expected commit. legba is not upstream's: bbot's
# legba module needs it and cannot fetch it itself on amd64 (see below).
# ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM ubuntu:26.10@sha256:1c2a84ae3f2a24aeb97cded5b41f0211b441662f1a188cbd2e139e7625f6f1d6 AS tools

ARG TARGETARCH
ARG DEBIAN_FRONTEND=noninteractive
ARG NUCLEI_VERSION
ARG NUCLEI_SHA256_AMD64
ARG NUCLEI_SHA256_ARM64
ARG HTTPX_VERSION
ARG HTTPX_SHA256_AMD64
ARG HTTPX_SHA256_ARM64
ARG SUBFINDER_VERSION
ARG SUBFINDER_SHA256_AMD64
ARG SUBFINDER_SHA256_ARM64
ARG KATANA_VERSION
ARG KATANA_SHA256_AMD64
ARG KATANA_SHA256_ARM64
ARG FFUF_VERSION
ARG FFUF_SHA256_AMD64
ARG FFUF_SHA256_ARM64
ARG DALFOX_VERSION
ARG DALFOX_SHA256_AMD64
ARG DALFOX_SHA256_ARM64
ARG LEGBA_VERSION
ARG LEGBA_SHA256_AMD64
ARG LEGBA_SHA256_ARM64
ARG SQLMAP_VERSION
ARG SQLMAP_COMMIT

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl git unzip \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	case "${TARGETARCH:-amd64}" in \
		amd64) PD_ARCH=amd64; DALFOX_ARCH=x86_64; LEGBA_ARCH=x86_64; LEGBA_SUM="$LEGBA_SHA256_AMD64"; \
			NUCLEI_SUM="$NUCLEI_SHA256_AMD64"; HTTPX_SUM="$HTTPX_SHA256_AMD64"; \
			SUBFINDER_SUM="$SUBFINDER_SHA256_AMD64"; KATANA_SUM="$KATANA_SHA256_AMD64"; \
			FFUF_SUM="$FFUF_SHA256_AMD64"; DALFOX_SUM="$DALFOX_SHA256_AMD64" ;; \
		arm64) PD_ARCH=arm64; DALFOX_ARCH=aarch64; LEGBA_ARCH=arm64; LEGBA_SUM="$LEGBA_SHA256_ARM64"; \
			NUCLEI_SUM="$NUCLEI_SHA256_ARM64"; HTTPX_SUM="$HTTPX_SHA256_ARM64"; \
			SUBFINDER_SUM="$SUBFINDER_SHA256_ARM64"; KATANA_SUM="$KATANA_SHA256_ARM64"; \
			FFUF_SUM="$FFUF_SHA256_ARM64"; DALFOX_SUM="$DALFOX_SHA256_ARM64" ;; \
		*) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
	esac; \
	mkdir -p /out; \
	fetch() { url="$1"; want="$2"; name="$3"; asset="${url##*/}"; \
		[ -n "$want" ] || { echo "no pinned digest for $asset" >&2; exit 1; }; \
		rm -rf /tmp/t; mkdir -p /tmp/t/x; \
		curl -fsSL --proto "=https" --proto-redir "=https" "$url" -o "/tmp/t/$asset"; \
		echo "$want  /tmp/t/$asset" | sha256sum -c -; \
		case "$asset" in *.zip) unzip -q "/tmp/t/$asset" -d /tmp/t/x ;; *) tar -xzf "/tmp/t/$asset" -C /tmp/t/x ;; esac; \
		find /tmp/t/x -type f -name "$name" -exec install -m 0755 {} /out/ \; ; \
		[ -x "/out/$name" ] || { echo "$name not found in $asset" >&2; exit 1; }; \
		rm -rf /tmp/t; }; \
	gh="https://github.com"; \
	fetch "$gh/projectdiscovery/nuclei/releases/download/$NUCLEI_VERSION/nuclei_${NUCLEI_VERSION#v}_linux_${PD_ARCH}.zip" "$NUCLEI_SUM" nuclei; \
	fetch "$gh/projectdiscovery/httpx/releases/download/$HTTPX_VERSION/httpx_${HTTPX_VERSION#v}_linux_${PD_ARCH}.zip" "$HTTPX_SUM" httpx; \
	fetch "$gh/projectdiscovery/subfinder/releases/download/$SUBFINDER_VERSION/subfinder_${SUBFINDER_VERSION#v}_linux_${PD_ARCH}.zip" "$SUBFINDER_SUM" subfinder; \
	fetch "$gh/projectdiscovery/katana/releases/download/$KATANA_VERSION/katana_${KATANA_VERSION#v}_linux_${PD_ARCH}.zip" "$KATANA_SUM" katana; \
	fetch "$gh/ffuf/ffuf/releases/download/$FFUF_VERSION/ffuf_${FFUF_VERSION#v}_linux_${PD_ARCH}.tar.gz" "$FFUF_SUM" ffuf; \
	fetch "$gh/hahwul/dalfox/releases/download/$DALFOX_VERSION/dalfox-${DALFOX_VERSION}-linux-${DALFOX_ARCH}-musl.tar.gz" "$DALFOX_SUM" dalfox; \
	fetch "$gh/evilsocket/legba/releases/download/$LEGBA_VERSION/legba-${LEGBA_VERSION}-linux-${LEGBA_ARCH}.tar.gz" "$LEGBA_SUM" legba; \
	test -n "$SQLMAP_VERSION"; \
	git clone --quiet --depth 1 --branch "$SQLMAP_VERSION" https://github.com/sqlmapproject/sqlmap /opt/sqlmap; \
	commit="$(git -C /opt/sqlmap rev-parse HEAD)"; \
	[ "$commit" = "$SQLMAP_COMMIT" ] || { echo "sqlmap commit mismatch: want $SQLMAP_COMMIT got $commit" >&2; exit 1; }; \
	rm -rf /opt/sqlmap/.git


# ----------------------------------------------------------------------------
# Python: uv-managed CPython, the bbot venv, and bbot's module dependencies.
# Everything lives under /opt at the same paths as in the runtime stage, so
# the venv's interpreter link resolves after the copy. Bytecode is compiled
# here: the executor uid cannot write __pycache__ under /opt at runtime.
# CPython's GUI parts (tkinter, Tcl/Tk, IDLE, turtle) are dropped: nothing in
# a headless image can use them.
# ----------------------------------------------------------------------------
FROM ubuntu:26.10@sha256:1c2a84ae3f2a24aeb97cded5b41f0211b441662f1a188cbd2e139e7625f6f1d6 AS python

ARG PYTHON_VERSION
ARG BBOT_VERSION
ARG NUCLEI_VERSION
ARG LEGBA_VERSION
ARG DEBIAN_FRONTEND=noninteractive

# The modules ARTEX's skills/bbot-recon/SKILL.md runs (modes P and A, the
# loud set, the baddns-heavy preset), the FINDING sources it names
# (aspnet_bin_exposure, telerik), and wafw00f, which upstream's image checks.
# bbot-deps.py adds the internal modules and json/txt outputs a scan loads.
ARG BBOT_MODULES=anubisdb,asn,aspnet_bin_exposure,baddns,baddns_direct,baddns_zone,badsecrets,bypass403,certspotter,crt,crt_db,dnsbrute,dnsbrute_mutations,dnscaa,dnscommonsrv,dnsdumpster,dnstlsrpt,emailformat,filedownload,fingerprintx,generic_ssrf,gowitness,graphql_introspection,hackertarget,host_header,http,hunt,iis_shortnames,ipneighbor,legba,lightfuzz,medusa,myssl,newsletters,nuclei,oauth,paramminer_cookies,paramminer_getparams,paramminer_headers,pgp,portscan,rapiddns,reflected_parameters,retirejs,robots,securitytxt,shodan_idb,skymem,sslcert,subdomaincenter,telerik,url_manipulation,urlscan,virtualhost,waf_bypass,wafw00f,wayback

ENV UV_PYTHON_INSTALL_DIR=/opt/python \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_COMPILE_BYTECODE=1

COPY bbot-deps.py /usr/local/lib/bbot-deps.py

# bbot keeps its tools, caches and dependency state under one home, ~/.bbot by
# default. ARTEX runs agents as an executor uid whose HOME is in the data
# volume, where a build-time ~/.bbot would never be seen; the package default
# is pointed at /opt/bbot-home instead (bbot has no system-wide config file).
#
# Three modules reuse what the image already ships rather than letting bbot
# download its own copy: nuclei and legba (same versions, checked below; both
# run from PATH) and retirejs (retire.js installed with bun, run by the
# image's Node instead of a private Node 18). legba has to: bbot names its
# amd64 asset "amd64" where the release uses "x86_64", and on arm64 it unpacks
# it into temp/, which is not on the PATH its modules run with. bbot's shared chromium dependency is not installed (it downloads
# an x86-64-only build and its apt steps fail on Ubuntu 26.10); gowitness gets
# Playwright's Chromium instead, linked in the runtime stage.
#
# build-essential/zlib1g-dev/git: wheels missing for some python/arch pairs
# (yara-python), and bbot compiles massdns, masscan and medusa from git.
# None of it leaves this stage.
RUN --mount=from=uv,source=/uv,target=/usr/local/bin/uv \
	--mount=from=bun,source=/usr/local/bin/bun,target=/usr/local/bin/bun \
	set -eux; \
	test -n "${PYTHON_VERSION}" -a -n "${BBOT_VERSION}" -a -n "${NUCLEI_VERSION}" -a -n "${LEGBA_VERSION}"; \
	apt-get update; \
	apt-get install -y --no-install-recommends build-essential zlib1g-dev git ca-certificates; \
	uv python install "${PYTHON_VERSION}"; \
	ln -s "$(uv python find "${PYTHON_VERSION}")" /opt/python/python3; \
	py_home="$(dirname "$(dirname "$(readlink -f /opt/python/python3)")")"; \
	rm -rf "$py_home"/lib/python3*/tkinter "$py_home"/lib/python3*/idlelib "$py_home"/lib/python3*/turtledemo \
		"$py_home"/lib/python3*/turtle.py "$py_home"/lib/python3*/lib-dynload/_tkinter* \
		"$py_home"/lib/libtcl* "$py_home"/lib/libtk* "$py_home"/lib/tcl* "$py_home"/lib/tk* "$py_home"/bin/idle*; \
	! /opt/python/python3 -c 'import tkinter' 2>/dev/null; \
	uv venv --seed --python "${PYTHON_VERSION}" /opt/bbot; \
	uv pip install --python /opt/bbot/bin/python "bbot==${BBOT_VERSION}"; \
	bbot_pkg="$(/opt/bbot/bin/python -c 'import bbot, os; print(os.path.dirname(bbot.__file__))')"; \
	sed -i 's|^home: ~/.bbot$|home: /opt/bbot-home|' "$bbot_pkg/defaults.yml"; \
	grep -qx 'home: /opt/bbot-home' "$bbot_pkg/defaults.yml"; \
	/opt/bbot/bin/python /usr/local/lib/bbot-deps.py "${BBOT_MODULES}" --skip legba,nuclei,retirejs --skip-common chromium; \
	cfg() { /opt/bbot/bin/python -c "from bbot.core.modules import MODULE_LOADER as m; print(m.preloaded()['$1']['config']['$2'])"; }; \
	[ "$(cfg nuclei version)" = "${NUCLEI_VERSION#v}" ] || { echo "bbot pins nuclei $(cfg nuclei version), image ships ${NUCLEI_VERSION}" >&2; exit 1; }; \
	[ "$(cfg legba version)" = "${LEGBA_VERSION}" ] || { echo "bbot pins legba $(cfg legba version), image ships ${LEGBA_VERSION}" >&2; exit 1; }; \
	mkdir -p /opt/bbot-home/tools/retirejs /opt/bbot-home/tools/node/bin; \
	(cd /opt/bbot-home/tools/retirejs && bun add --exact "retire@$(cfg retirejs version)"); \
	ln -s /usr/bin/node /opt/bbot-home/tools/node/bin/node; \
	/opt/bbot/bin/bbot --version; \
	cd /opt/bbot-home; \
	core="$(/opt/bbot/bin/python -c 'import mmh3, orjson; from bbot.core.helpers.depsinstaller.installer import DepsInstaller as D; print(mmh3.hash(orjson.dumps(D.CORE_DEPS, option=orjson.OPT_SORT_KEYS)))')"; \
	test -f "cache/$core"; \
	rm -rf temp scans logs tools/sudo_askpass.py cache/depsinstaller/playbook_* cache/depsinstaller/minimal_git.config cache/depsinstaller/setup_status.json /root/.bun; \
	find cache -mindepth 1 -maxdepth 1 ! -name depsinstaller ! -name "$core" -exec rm -rf {} +; \
	find cache cache/depsinstaller cache/depsinstaller/command_status lib tools -maxdepth 1 -type f -empty -name '.*' -delete


# ----------------------------------------------------------------------------
# Playwright MCP + CLI, installed with bun, plus the one browser they drive.
# MCP and CLI pin a playwright-core prerelease while upstream also ships
# playwright@PLAYWRIGHT_VERSION, which wants a different Chromium revision, so
# upstream carries two. An override pins everything to PLAYWRIGHT_VERSION
# (checked below: exactly one playwright-core), so one Chromium revision serves
# MCP, CLI and the test runner. Drop the override once MCP/CLI pin it too.
# @playwright/test and puppeteer-core (api-recon's harvester, version from its
# package-lock.json) are prebuilt here and found through NODE_PATH, so agents
# need no registry access for them. ARTEX runs MCP with --headless --browser chromium,
# which still launches full Chromium (new headless mode, verified), so the
# separate headless shell is not installed (--no-shell). Node runs the
# download here and the packages at runtime: Playwright does not run reliably
# on bun. Headless browsing needs neither the Widevine DRM module nor UI
# translations, so those go (Chromium falls back to en-US).
# ----------------------------------------------------------------------------
FROM ubuntu:26.10@sha256:1c2a84ae3f2a24aeb97cded5b41f0211b441662f1a188cbd2e139e7625f6f1d6 AS playwright

ARG DEBIAN_FRONTEND=noninteractive
ARG PLAYWRIGHT_MCP_VERSION
ARG PLAYWRIGHT_CLI_VERSION
ARG PLAYWRIGHT_VERSION
ARG PUPPETEER_CORE_VERSION

ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

WORKDIR /opt/playwright

RUN --mount=from=bun,source=/usr/local/bin/bun,target=/usr/local/bin/bun \
	set -eux; \
	test -n "${PLAYWRIGHT_MCP_VERSION}" -a -n "${PLAYWRIGHT_CLI_VERSION}" -a -n "${PLAYWRIGHT_VERSION}" -a -n "${PUPPETEER_CORE_VERSION}"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates nodejs; \
	printf '{"overrides":{"playwright":"%s","playwright-core":"%s"}}\n' "${PLAYWRIGHT_VERSION}" "${PLAYWRIGHT_VERSION}" > package.json; \
	bun add --exact "@playwright/mcp@${PLAYWRIGHT_MCP_VERSION}" "@playwright/cli@${PLAYWRIGHT_CLI_VERSION}" \
		"playwright@${PLAYWRIGHT_VERSION}" "@playwright/test@${PLAYWRIGHT_VERSION}" "puppeteer-core@${PUPPETEER_CORE_VERSION}"; \
	cores="$(find node_modules -path '*/playwright-core/package.json' | wc -l)"; \
	[ "$cores" -eq 1 ] || { echo "expected one playwright-core, found $cores" >&2; exit 1; }; \
	[ "$(node -p "require('playwright-core/package.json').version")" = "${PLAYWRIGHT_VERSION}" ]; \
	node node_modules/playwright-core/cli.js install --no-shell chromium; \
	chrome_dir="$(dirname "$(find "${PLAYWRIGHT_BROWSERS_PATH}" -path '*/chromium-*' -type f -name chrome)")"; \
	test -f "$chrome_dir/locales/en-US.pak"; \
	rm -rf "$chrome_dir/WidevineCdm"; \
	find "$chrome_dir/locales" -type f ! -name en-US.pak -delete; \
	rm -rf /root/.bun


# ----------------------------------------------------------------------------
# Runtime
# ----------------------------------------------------------------------------
FROM ubuntu:26.10@sha256:1c2a84ae3f2a24aeb97cded5b41f0211b441662f1a188cbd2e139e7625f6f1d6

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/artex"
LABEL org.opencontainers.image.description="ARTEX - AI autonomous penetration testing system"

ARG DEBIAN_FRONTEND=noninteractive

# Browsers and bbot's home live under /opt so the executor uid (agent
# processes, see server/execpriv_unix.go) can use them without access to
# root's home.
#
# bbot refuses to start unless it can write into each of its dirs (cache,
# cache/depsinstaller{,/command_status}, lib, temp, scans, logs, tools,
# tools/nuclei-state), tools included, so they are sticky and world-writable
# like /tmp: the executor can add files but not replace the root-owned
# binaries. They ship with no root-owned file bbot would need to write:
#   - tools/sudo_askpass.py is re-copied on every start, so none ships;
#   - depsinstaller/setup_status.json is rewritten on every start (and keyed
#     by hostname, so a build-time copy could never match), so none ships;
#   - cache/<hash>, bbot's read-only "core deps installed" marker, does ship:
#     its core list includes gcc, make and OpenSSL headers, which only its
#     installers use, and those never run at runtime (--no-deps).
# bbot also leaves an empty .<random> probe file in each dir per run; the
# build removes its own.
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright \
	NODE_PATH=/opt/playwright/node_modules \
	PATH="/opt/playwright/node_modules/.bin:${PATH}"

COPY --from=python /opt/python /opt/python
COPY --from=python /opt/bbot /opt/bbot
COPY --from=python /opt/bbot-home /opt/bbot-home
COPY --from=playwright /opt/playwright /opt/playwright
COPY --from=playwright /opt/ms-playwright /opt/ms-playwright
COPY --from=tools /out/ /usr/local/bin/
COPY --from=tools /opt/sqlmap /opt/sqlmap

# One apt layer:
#   agent shell tools and recon staples (upstream's list);
#   nodejs: runs Playwright and retire.js;
#   7zip, bzip2: bbot's unarchive module (tar -j / 7z x);
#   libpcap0.8t64: masscan dlopen()s libpcap.so.0.8 (its libibverbs1 needs
#     systemd-sysusers; the standalone package satisfies that without systemd);
#   libssl4, libzstd1, zlib1g: linked by medusa;
#   Chromium's shared libraries and fonts (playwright install-deps), minus
#     fonts-unifont, a 33 MB bitmap fallback for rare scripts (the CJK, Thai,
#     Latin and emoji fonts stay).
# uv's CPython is linked as python/python3 ahead of Ubuntu's own; sqlmap and
# agent scripts run on it.
RUN set -eux; \
	apt-get update; \
	apt-get dist-upgrade -y; \
	apt-get install -y --no-install-recommends \
		ca-certificates ripgrep curl wget vim git jq unzip xz-utils \
		dnsutils iputils-ping netcat-openbsd inetutils-telnet whois nmap \
		nodejs 7zip bzip2 libpcap0.8t64 systemd-standalone-sysusers libssl4 libzstd1 zlib1g; \
	playwright install-deps chromium; \
	apt-get purge -y fonts-unifont; \
	apt-get autoremove -y --purge; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*; \
	ln -s /opt/python/python3 /usr/local/bin/python3; \
	ln -s /opt/python/python3 /usr/local/bin/python; \
	ln -s /opt/bbot/bin/bbot /usr/local/bin/bbot; \
	ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap; \
	chrome="$(find "${PLAYWRIGHT_BROWSERS_PATH}" -path '*/chromium-*' -type f -name chrome)"; \
	test "$(echo "$chrome" | wc -l)" -eq 1 -a -x "$chrome"; \
	mkdir /opt/bbot-home/tools/chrome-linux; \
	ln -s "$chrome" /opt/bbot-home/tools/chrome-linux/chrome; \
	ln -s "$chrome" /usr/bin/chromium; \
	node -e "require('@playwright/test'); require('puppeteer-core')"; \
	cd /opt/bbot-home; \
	mkdir -p temp scans logs tools/nuclei-state; \
	chmod 1777 cache cache/depsinstaller cache/depsinstaller/command_status lib temp scans logs tools tools/nuclei-state; \
	python3 --version; node --version; "$chrome" --version; \
	playwright-mcp --help >/dev/null; playwright-cli --help >/dev/null; \
	nuclei -version >/dev/null 2>&1; httpx -version; subfinder -version; katana -version; \
	ffuf -V >/dev/null; dalfox --version >/dev/null; sqlmap --version >/dev/null; legba --version; \
	ldconfig -p | grep -q 'libpcap.so.0.8 '; \
	runs() { rc=0; "$@" >/dev/null 2>&1 || rc=$?; [ "$rc" -ne 126 ] && [ "$rc" -ne 127 ]; }; \
	for t in massdns masscan medusa gowitness fingerprintx; do runs "tools/$t" --help || { echo "$t does not run" >&2; exit 1; }; done; \
	node tools/retirejs/node_modules/.bin/retire --version; \
	bbot --version; \
	core="$(/opt/bbot/bin/python -c 'import mmh3, orjson; from bbot.core.helpers.depsinstaller.installer import DepsInstaller as D; print(mmh3.hash(orjson.dumps(D.CORE_DEPS, option=orjson.OPT_SORT_KEYS)))')"; \
	test -f "cache/$core"; \
	rm -rf logs/* temp/* scans/* tools/sudo_askpass.py; \
	find cache cache/depsinstaller cache/depsinstaller/command_status lib tools -maxdepth 1 -type f -empty -name '.*' -delete; \
	find cache -mindepth 1 -maxdepth 1 ! -name depsinstaller ! -name "$core" -exec rm -rf {} +; \
	leftover="$(find cache lib temp scans logs tools/nuclei-state -mindepth 1 ! -path cache/depsinstaller ! -path cache/depsinstaller/command_status ! -path "cache/$core")"; \
	[ -z "$leftover" ] || { echo "unexpected files in bbot's writable dirs: $leftover" >&2; exit 1; }

WORKDIR /app

COPY --from=build --chmod=0755 /out/artex /app/artex
# start.sh relaunches artex after a crash and forwards SIGTERM to it (docker
# stop signals PID 1 only).
COPY --from=src --chmod=0755 /src/start.sh /app/start.sh
COPY --from=src /src/skills/ /app/skills/

# ARTEX runs as root by design: it drops every agent process to a separate
# executor uid itself, which needs root. In exchange: no setuid/setgid
# programs, so an agent process cannot regain root through one.
RUN mkdir -p -m 0700 /app/keys \
	&& find / -xdev -perm /6000 -type f -exec chmod a-s {} +

# data/: traffic index, task files, transcripts. keys/: jwt.key, secret.key.
VOLUME ["/app/data", "/app/keys"]

# 8787: web UI / API, 8788: intercepting proxy
EXPOSE 8787 8788

ENTRYPOINT ["/app/start.sh"]
CMD ["-addr", ":8787", "-proxy", ":8788"]
