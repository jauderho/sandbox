#!/usr/bin/env bash
#
# Install/update the Homefront dedicated server via SteamCMD, then run it under
# Wine. The game files live in ${HF_DIR}, which is a volume - they are not baked
# into the image (the depot is several GB and changes independently of it).
#
set -euo pipefail

HF_DIR="${HF_DIR:-/data/homefront}"
HF_APPID="${HF_APPID:-55280}"
HF_EXE="${HF_EXE:-binaries/HFDedicated.exe}"
HF_SKIP_UPDATE="${HF_SKIP_UPDATE:-0}"

# Server tunables. HF_ARGS overrides the lot if you want full control.
HF_MAP="${HF_MAP:-SERVER}"
HF_MAXPLAYERS="${HF_MAXPLAYERS:-32}"
HF_QUERYPORT="${HF_QUERYPORT:-27015}"
HF_AUTHPORT="${HF_AUTHPORT:-8766}"
HF_RCONPORT="${HF_RCONPORT:-27010}"
HF_RCONPORT2="${HF_RCONPORT2:-27011}"
HF_CONFIGSUBDIR="${HF_CONFIGSUBDIR:-DedicatedProfile_DefaultProfile}"

export WINEPREFIX="${WINEPREFIX:-/data/wineprefix}"
export WINEARCH="${WINEARCH:-win32}"
export WINEDEBUG="${WINEDEBUG:--all}"

log() { printf '[homefront] %s\n' "$*"; }

if [[ "${HF_SKIP_UPDATE}" != "1" ]]; then
	log "installing/updating app ${HF_APPID} into ${HF_DIR}"
	# Homefront only ships a Windows build, so SteamCMD has to be told to pull
	# the windows depot even though it is running on Linux.
	steamcmd \
		+@sSteamCmdForcePlatformType windows \
		+force_install_dir "${HF_DIR}" \
		+login anonymous \
		+app_update "${HF_APPID}" validate \
		+quit
else
	log "HF_SKIP_UPDATE=1, skipping SteamCMD"
fi

if [[ ! -f "${HF_DIR}/${HF_EXE}" ]]; then
	log "ERROR: ${HF_DIR}/${HF_EXE} not found after update."
	log "Set HF_EXE if the server binary lives elsewhere. Contents of ${HF_DIR}:"
	ls -la "${HF_DIR}" || true
	exit 1
fi

if [[ ! -d "${WINEPREFIX}" ]]; then
	log "initialising ${WINEARCH} wine prefix at ${WINEPREFIX}"
	wineboot --init
	wineserver --wait
fi

if [[ $# -gt 0 ]]; then
	exec "$@"
fi

# Defaults per the FireDaemon writeup linked in README.md.
if [[ -n "${HF_ARGS:-}" ]]; then
	# shellcheck disable=SC2206
	args=(${HF_ARGS})
else
	args=(
		"${HF_MAP}?maxplayers=${HF_MAXPLAYERS}"
		-queryport="${HF_QUERYPORT}"
		-authport="${HF_AUTHPORT}"
		-rconport="${HF_RCONPORT}"
		-rconport2="${HF_RCONPORT2}"
		-runasserver
		-configsubdir="${HF_CONFIGSUBDIR}"
	)
fi

cd "${HF_DIR}"
log "starting: wine ${HF_EXE} ${args[*]}"
exec wine "${HF_EXE}" "${args[@]}"
