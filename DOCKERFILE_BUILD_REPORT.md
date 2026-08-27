# Dockerfile build audit and fixes — 2026-08-27

All 58 Dockerfiles were built individually (`docker build`, each directory as its
own context, `linux/arm64` natively except where an amd64-only artifact forced
`linux/amd64`). Each image was deleted immediately after its build and the cache
pruned; Docker is back to empty.

Initial state: **19 pass, 36 broken, 3 not verifiable.**
After the fixes below: **35 pass**, with the remainder listed under
"Still outstanding".

Everything under `done/` was left alone as requested.

---

## Fixed and verified building

### PEP 668 `externally-managed-environment`

Ubuntu 26.04 and Alpine 3.24 mark the system Python as externally managed, so
`pip3 install` refused outright. Added `--break-system-packages` (and
`--ignore-installed` on the pip self-upgrade), matching the pattern already in
`awscli/Dockerfile`:

`autoflake/Dockerfile` · `autoflake/Dockerfile.ubuntu` ·
`awscli/Dockerfile.1.16.14` · `greynoise/Dockerfile.alpine` ·
`jc/Dockerfile.ubuntu` · `memray/Dockerfile.ubuntu` ·
`openbbterminal/Dockerfile` · `openbbterminal/Dockerfile.alpine` ·
`ssh-mitm/Dockerfile`

### pip self-upgrade `uninstall-no-record-file`

pip tried to uninstall the Debian-packaged `pip`/`packaging`, which ship no
`RECORD`. Added `--ignore-installed`:

- `greynoise/Dockerfile`, `shodan/Dockerfile` — on the pip upgrade
- `huggingface-cli/Dockerfile`, `openbbterminal/Dockerfile` — also on the
  `-r requirements.txt` install, which collided with Debian's `packaging`

### Stale pins

- **`aider`** — `aider-chat` declares `Requires-Python >=3.10,<3.13` and 0.86.2 is
  the current release, so the pin was not stale: the *base* was. Alpine 3.24 ships
  Python 3.14. Base changed to `python:3.12-alpine3.22` (digest-pinned) and
  `requires-python` set to `>=3.12,<3.13` so uv resolves against the same
  interpreter the image runs.
- **`open-interpreter`** — `litellm==1.40.1` had been pulled from PyPI. Added an
  `open-interpreter>=0.4.3` floor (uv was otherwise picking the 2024-era 0.3.4)
  and relocked → `open-interpreter 0.4.3`, `litellm 1.83.0`. 0.4.3 hard-caps
  `tiktoken<0.8.0`, and tiktoken 0.7.x has no cp313/cp314 wheels (its pyo3 0.20
  cannot build against Python 3.14), so this base also moved to
  `python:3.12-alpine3.22`. Workflow `BUILD_VERSION` bumped `v0.2.5` → `v0.4.3`.
- **`llama-fs`** — `onnxruntime` (via chromadb) publishes manylinux wheels only;
  there is no musl build for any arch. Base moved from Alpine to Ubuntu 26.04,
  where the cp314 manylinux_2_28 wheel installs cleanly.
- **`llama-cpp-agent`** — `llama-cpp-python` ships no wheels and was compiling
  against an empty `build_pkgs`. Added `build-base cmake git linux-headers
  musl-dev ninja python3-dev` (it needed `linux/limits.h`) and `libstdc++` at
  runtime.
- **`ssh-mitm`** — `cffi==1.17.1` conflicted with the rest of the lock. Relocked
  (`uv lock -U && uv export`); it is not in `scripts/updatePythonDepsUV.sh`, which
  is why it had drifted.
- **`openbbterminal`** — `arch` and `linearmodels` have no aarch64 wheels; added
  `build-essential python3-dev gfortran`.

### `awscli` — both builds

`awscli/Dockerfile` was already fine. `awscli/Dockerfile.1.16.14` had two
problems: PEP 668, and a `requirements.1.16.14.txt` that Dependabot had walked
into an incoherent state — it had been bumping individual packages inside the
file (`awscli` 1.16.14 → 1.45.28, `pyyaml` 3.13 → 5.4, `rsa`, `urllib3`, `pyasn1`)
while leaving `botocore==1.12.4`, `jmespath==0.10.0`, `colorama==0.3.9` and
`s3transfer==0.1.13` at their 2018 versions. The result could not resolve, and
`pyyaml==5.4` cannot build against modern Python. Regenerated with the command in
the file's own header, plus `--upgrade` (without it uv treats the existing output
file as pins and faithfully reproduces the broken set).

**Worth a decision:** this file no longer pins 1.16.14 in any meaningful sense —
it now resolves to the same content as `requirements.txt`, so the variant is
effectively a duplicate. Either delete it, or exclude it from Dependabot so the
1.16.14 pin can be restored and actually held.

### `caddy-docker-proxy`

`CADDY_VERSION=2.8.4` gave a builder image with Go 1.23.4, while
`caddy-docker-proxy/v2@v2.13.1` requires Go ≥ 1.26. Brought up to date and
tightened per `AGENTS.md`:

- Caddy 2.8.4 → 2.11.4, base pinned by digest (`caddy:2.11.4-builder-alpine`,
  Go 1.26.7)
- `xcaddy build "v${CADDY_VERSION}"` so the Caddy version is pinned rather than
  whatever `xcaddy` resolves
- plugins pinned: `caddy-docker-proxy/v2@v2.13.1`, `caddy-dns/cloudflare@v0.2.4`
- added the standard OCI labels and `HEALTHCHECK NONE`

### `pingcastle`

The workflow was already on a Windows runner (`windows-2022`, still GA) — the
Dockerfile was the problem:

- the download URL was hardcoded to 3.2.0.1 and ignored `BUILD_VERSION` /
  `ARCHIVE_URL`; now built from both, with a guard if `BUILD_VERSION` is unset
- `CMD ["c:\app\pingcastle.exe"]` was not valid JSON (`\a`, `\p` are not JSON
  escapes); now `ENTRYPOINT ["c:\\app\\PingCastle.exe"]`
- the validation step ran the bare executable, which drops into PingCastle's
  interactive menu and would hang a build; now `--help`
- upstream moved `vletoux/pingcastle` → `netwrix/pingcastle`; `ARCHIVE_URL`
  updated and the workflow bumped 3.2.0.1 → **4.0.0.20**
- added the standard OCI labels

Kept on `windows-2022`/`ltsc2022`: `mcr.microsoft.com/powershell` publishes no
ltsc2025 tag, so moving the runner to `windows-2025` would force Hyper-V
isolation. The pinned base digest is still current.

### `pstcli`

The published `ghcr.io/jauderho/pstcli:latest` (built 2026-06-29) contains
`/opt/dellemc/pstcli-4.3.0.0.1661`, which is the newest release that can be
confirmed: Dell's own driver page for the Linux x64 RPM
([driverid `nntwn`](https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=nntwn))
still serves 4.1.0.0.1338 from June 2025, nothing above 4.3.0.0.1661 is indexed
anywhere, and Dell's driver-search APIs are Akamai-blocked.

Each release gets its own opaque `dl.dell.com` folder id that cannot be derived
from the version:

    FOLDER12722122M  4.1.0.0.1338
    FOLDER13576510M  4.2.0.0.1553
    FOLDER13877768M  4.3.0.0.1661

So the folder is now its own `FOLDER_VERSION` build arg (the Dockerfile already
declared one but never used it) rather than being baked into `ARCHIVE_URL`, and
both the Dockerfile and the workflow document that the two must be bumped
together. `curl` also gained `-f`: `dl.dell.com` answers a default curl
user-agent with an Akamai "Access Denied" page, and without `-f` curl saved that
HTML and handed it to `rpm`/`alien`, which is what produced the original
"error: open of <HTML><HEAD> failed" noise. All three files pass a browser
user-agent.

The `.alpine` and `.ubuntu` variants had additionally pointed at a stale
`FOLDER08713913M` (404) and used a bare `curl -O`.

**Verified on a real amd64 host** (this cannot be built under Rosetta — AlmaLinux
10 requires x86-64-v3): the image builds with the workflow's explicit
`--build-arg` pair, `pstcli -h` runs, and `/opt/dellemc/pstcli-4.3.0.0.1661` is
installed. A deliberately wrong `FOLDER_VERSION` now fails the build instead of
silently installing an HTML error page.

### `pstcli` workflow

Added `.github/workflows/pstcli.yml`, modelled on `cryptolyzer.yml`: pinned
action hashes, `harden-runner` with an allowlist that includes `dl.dell.com`,
push to ghcr.io and GitLab (Docker Hub left commented out, matching the others),
SBOM and provenance on. `linux/amd64` only — Dell ships pstcli as an x86_64 RPM
with no arm64 build. `BUILD_VERSION` and `FOLDER_VERSION` are both in `env:` and
passed through as build args.

---

### Remaining five

- **`uv`** — the directory held only a Dockerfile, so `COPY requirements.txt .`
  failed immediately. Added `pyproject.toml` (pinning `uv`), generated
  `requirements.txt` + `uv.lock` with the repo's own uv command, added the
  standard `README.md`, and added `--ignore-installed` to the pip self-upgrade.
- **`hollywood`** — `mlocate` was removed from Ubuntu 26.04; switched to
  `plocate`, which provides `/usr/bin/updatedb` via alternatives so the existing
  `updatedb` call still works. The `hollywood` package itself is still in the
  archive.
- **`mold`** — `clang-14` and `libstdc++-11-dev` are long gone. Switched to the
  unversioned `clang` metapackage and dropped `libstdc++-dev` entirely: it is a
  virtual package with no installation candidate, and `build-essential` already
  pulls the matching `libstdc++-N-dev` through `g++`.
- **`sgpt`** — two problems. `pip install /app` resolves `shell_gpt` from git, so
  `git` is now installed for the build and purged afterwards. The base was also
  `python:3.15.0b3-slim-trixie`, and `jiter` publishes no cp315 wheel, so it and
  `pydantic-core` both fell back to a cargo build; moved to
  `python:3.14-slim-trixie`, where wheels exist for everything.
- **`jless`** (and `Dockerfile.curl`) — three layers of breakage. The `xcb 0.8.2`
  build script shells out to `python3`, which was not installed. Once it ran, the
  musl target's default static link failed because Alpine ships no `.a` archives
  for libxcb/libXau/libXdmcp; the build now passes
  `-C target-feature=-crt-static` and links dynamically, with `libxcb libxau
  libxdmcp libgcc` added to the final image. Finally, both smoke-test steps ran
  `jless` bare, which reads stdin, hits EOF and exits 1 — they now use
  `--version`.

## Still outstanding

- **`pstcli/Dockerfile.alpine`, `pstcli/Dockerfile.ubuntu`** — download is fixed,
  but the `alien` rpm→deb conversion still fails (`dpkg-deb --build ... exit code
  2` / "could not run generated debian/rules"). These are alternates; the shipped
  image is the AlmaLinux one, which builds and runs.
- **`openbbterminal/Dockerfile.alpine`** — `pywry` → `pytauri-wheel` → `glib-sys`
  needs the full GTK/WebKit native stack, because there is no musl wheel for
  pywry. Added the obvious build deps and left a note in the file; finishing it
  means pulling a desktop GUI toolchain into a headless image. The Ubuntu
  Dockerfile gets pywry from a manylinux wheel and builds fine.
- **`pingcastle`** — Dockerfile parses clean (`docker build --check`), but a
  Windows image cannot be built on this Linux daemon. Needs a CI run to confirm.

`./Dockerfile` at the repo root is the documented digest-tracking dummy and is not
a build target.

---

## New: `homefront`

Self-hosted dedicated server for Homefront (2011). Homefront only ever shipped a
*Windows* dedicated server, so this runs `binaries/HFDedicated.exe` under Wine on
Linux, per the links in `homefront/README.md`.

- **Base:** `ubuntu:26.04` with i386 multiarch. Alpine will not work — its `wine`
  package is 64-bit only, and both SteamCMD and `HFDedicated.exe` are 32-bit x86.
  The image is amd64-only for the same reason.
- **The game is not baked into the image.** The depot (Steam app `55280`) is
  several GB and versions independently of the image, so `entrypoint.sh` installs
  or updates it into `/data` on start via SteamCMD, using
  `+@sSteamCmdForcePlatformType windows` so a Linux SteamCMD pulls the Windows
  depot. Mount a volume at `/data` or it re-downloads every start.
- **Defaults** follow the FireDaemon writeup linked in the README:
  `SERVER ?maxplayers=32 -queryport=27015 -authport=8766 -rconport=27010
  -rconport2=27011 -runasserver -configsubdir=DedicatedProfile_DefaultProfile`.
  Every field is overridable by environment variable, and `HF_ARGS` replaces the
  lot. Anything passed after the image name replaces the server command entirely.
- Runs as a non-root `steam` user, under `tini`, with `STOPSIGNAL SIGINT`.
- The workflow moved from `windows-2022` to `ubuntu-26.04`, its build context
  changed from the repo root to `homefront/` (the Dockerfile now copies
  `entrypoint.sh`), and `BUILD_VERSION` was reset from `2.10.1.0` — which was
  PingCastle's version, copy-pasted — to `1.0.0`, since the image version tracks
  the image, not the game.

Verified by building on a real amd64 host: the image builds, and inside it Wine
10.0 and SteamCMD both run as the unprivileged user. SteamCMD's actual depot
download and the server launch are untested — that host ran out of disk
("Steamcmd needs at least 250MB of free disk space"), and it cannot be tested on
this Mac at all, since Rosetta cannot run the 32-bit SteamCMD binary.

## Caveats

- Verification builds ran on `linux/arm64`. The PEP 668, pin, package-rename and
  toolchain fixes are arch-independent; the wheel-availability ones
  (`llama-fs`, `llama-cpp-agent`, `openbbterminal`) were arm64-specific problems,
  and the fixes are supersets of what amd64 needs.
- `aider` and `open-interpreter` are now pinned to Python 3.12 rather than
  tracking the Alpine default. Both upstreams cap out below 3.13; revisit when
  they support newer interpreters.
