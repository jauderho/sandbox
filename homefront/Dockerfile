# Homefront (2011) only ever shipped a Windows dedicated server, so this runs the
# Windows binary under Wine on Linux rather than using a Windows base image.
#
# The old Windows base is kept here for reference:
#FROM steamcmd/steamcmd:windows-core-2019@sha256:bd201be10050af5eb09dc4293a38191a1258763641dbd9f1827cae2b0b3eab67
#
# Alpine is not usable: its wine package is 64-bit only, and HFDedicated.exe is a
# 32-bit binary. Ubuntu with i386 multiarch gives us wine32.
FROM ubuntu:26.04@sha256:3131b4cc82a783df6c9df078f86e01819a13594b865c2cad47bd1bca2b7063bb

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive
# steamcdn-a.akamaihd.net no longer resolves; media.steampowered.com is the
# current host for the SteamCMD tarball
ARG STEAMCMD_URL=https://media.steampowered.com/client/installer/steamcmd_linux.tar.gz

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/homefront"
LABEL org.opencontainers.image.description="Self-hosted dedicated server for Homefront, running under Wine"

# SteamCMD is a 32-bit binary, and so is HFDedicated.exe, hence i386 multiarch.
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		lib32gcc-s1 \
		lib32stdc++6 \
		procps \
		tini \
		wine \
		wine32 \
		wine64 \
		winbind \
		xvfb \
		xauth && \
	mkdir -p /opt/steamcmd && \
	curl -fsSL --proto '=https' --proto-redir '=https' "${STEAMCMD_URL}" | tar xzf - -C /opt/steamcmd && \
	printf '#!/bin/sh\nexec /opt/steamcmd/steamcmd.sh "$@"\n' > /usr/local/bin/steamcmd && \
	chmod 755 /usr/local/bin/steamcmd && \
	apt-get autoremove -y --purge && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

# Run as an unprivileged user. /data holds both the game files and the wine
# prefix, so mount a volume there to avoid re-downloading on every start.
RUN useradd --system --create-home --home-dir /home/steam --shell /usr/sbin/nologin steam && \
	mkdir -p /data && \
	chown -R steam:steam /data /opt/steamcmd

ENV HF_DIR=/data/homefront \
	HF_APPID=55280 \
	HF_EXE=binaries/HFDedicated.exe \
	WINEPREFIX=/data/wineprefix \
	WINEARCH=win32 \
	WINEDEBUG=-all

VOLUME ["/data"]
WORKDIR /data

# query, auth, rcon, rcon2 and the UE3 game port
EXPOSE 27015/udp 8766/udp 27010/tcp 27011/tcp 7777/udp

USER steam
HEALTHCHECK NONE
STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
