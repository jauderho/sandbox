[![Build Status](https://github.com/jauderho/dockerfiles/workflows/homefront/badge.svg)](https://github.com/jauderho/dockerfiles/actions)
[![Version](https://img.shields.io/docker/v/jauderho/homefront/latest)](https://store.steampowered.com/app/55100/Homefront/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jauderho/homefront)](https://hub.docker.com/r/jauderho/homefront/)
[![Image Size](https://img.shields.io/docker/image-size/jauderho/homefront/latest)](https://hub.docker.com/r/jauderho/homefront/)

Self-hosted dedicated server for **Homefront** (2011, Kaos Studios/THQ).

Homefront only ever shipped a *Windows* dedicated server, so this image runs
`HFDedicated.exe` under Wine on Linux. It is **amd64 only** — both SteamCMD and
`HFDedicated.exe` are 32-bit x86 binaries, which is also why the base is Ubuntu
with i386 multiarch rather than Alpine (Alpine's `wine` package is 64-bit only).

The image contains only SteamCMD and Wine. The game depot (Steam app `55280`) is
downloaded on first start into `/data`, so mount a volume there — otherwise it
re-downloads several GB every time the container starts.

## Usage

```
docker run -d --name homefront \
  -v homefront-data:/data \
  -p 27015:27015/udp \
  -p 8766:8766/udp \
  -p 7777:7777/udp \
  -p 27010:27010/tcp \
  -p 27011:27011/tcp \
  ghcr.io/jauderho/homefront:latest
```

First start pulls the depot via SteamCMD (anonymous login), initialises a 32-bit
Wine prefix in `/data/wineprefix`, then launches the server.

## Configuration

| Variable | Default | Notes |
| --- | --- | --- |
| `HF_DIR` | `/data/homefront` | Where the depot is installed |
| `HF_APPID` | `55280` | Steam app id for the dedicated server |
| `HF_EXE` | `binaries/HFDedicated.exe` | Server binary, relative to `HF_DIR` |
| `HF_MAP` | `SERVER` | Startup map/URL |
| `HF_MAXPLAYERS` | `32` | |
| `HF_QUERYPORT` | `27015` | |
| `HF_AUTHPORT` | `8766` | |
| `HF_RCONPORT` | `27010` | |
| `HF_RCONPORT2` | `27011` | |
| `HF_CONFIGSUBDIR` | `DedicatedProfile_DefaultProfile` | |
| `HF_ARGS` | unset | Overrides all of the above and is passed verbatim |
| `HF_SKIP_UPDATE` | `0` | Set to `1` to skip the SteamCMD step on start |

Anything passed after the image name replaces the server command, which is handy
for poking around:

```
docker run --rm -it -v homefront-data:/data ghcr.io/jauderho/homefront:latest bash
```

## Notes

The default arguments follow the FireDaemon writeup linked below:

```
SERVER ?maxplayers=32 -queryport=27015 -authport=8766 -rconport=27010 -rconport2=27011 -runasserver -configsubdir=DedicatedProfile_DefaultProfile
```

SteamCMD is invoked with `+@sSteamCmdForcePlatformType windows` so that it pulls
the Windows depot while running on Linux.

## References

https://github.com/r-pufky/steam
https://kb.firedaemon.com/support/solutions/articles/4000086967-homefront-as-a-windows-service

+login anonymous +force_install_dir "C:\Homefront" +app_update 55280 validate +quit

C:\SteamCMD\steamcmd.exe +login anonymous +force_install_dir "C:\Homefront" +app_update 55280 validate +quit

https://steamdb.info/app/55280/subs/

https://steamcommunity.com/dev/managegameservers

https://hub.docker.com/r/jammsen/the-forest-dedicated-server

docker run -it steamcmd/steamcmd:latest +login anonymous +app_update 740 +quit

https://github.com/webanck/docker-wine-steam/blob/master/Dockerfile

https://steamcommunity.com/sharedfiles/filedetails/?l=greek&id=2152208139

https://github.com/GloriousEggroll/proton-ge-custom

https://dev.to/flpslv/running-winehq-inside-a-docker-container-52ej

https://wiki.winehq.org/Winetricks
