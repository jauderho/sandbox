# For Windows images, the base os version has to match the container os version.
# The workflow runs on the windows-2022 runner, so the base must stay on ltsc2022
# (mcr.microsoft.com/powershell publishes no ltsc2025 variant).
#
## Set the base image
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1809 AS base
#FROM mcr.microsoft.com/windows/nanoserver:1809
#FROM mcr.microsoft.com/windows/servercore:1809
#FROM mcr.microsoft.com/windows:10.0.19042.1469
#FROM mcr.microsoft.com/powershell:lts-nanoserver-1809
#FROM mcr.microsoft.com/powershell:lts-nanoserver-ltsc2022
FROM mcr.microsoft.com/powershell:lts-windowsservercore-ltsc2022@sha256:4d58db7a0242824875f60449f8ebe482e14c15470b2a9a7ca1bce0172770240c
#FROM mcr.microsoft.com/powershell

WORKDIR /app
#EXPOSE 80

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/netwrix/pingcastle/releases/download/

LABEL org.opencontainers.image.authors="Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source="https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title="jauderho/pingcastle"
LABEL org.opencontainers.image.description="PingCastle is an Active Directory security assessment tool"

# download
RUN powershell -Command \
	$ErrorActionPreference = 'Stop' ; \
	if (-not $env:BUILD_VERSION) { throw 'BUILD_VERSION is required' } ; \
	$url = $env:ARCHIVE_URL + $env:BUILD_VERSION + '/PingCastle_' + $env:BUILD_VERSION + '.zip' ; \
	Invoke-WebRequest -Method Get -UseBasicParsing -Uri $url -OutFile c:\app\pingcastle.zip ; \
	Expand-Archive -Path c:\app\pingcastle.zip -DestinationPath c:\app ; \
	Remove-Item c:\app\pingcastle.zip -Force

#RUN dir
RUN dir c:\app

# validation - --help exits cleanly; a bare invocation drops into the interactive
# menu and would hang the build
RUN c:\app\PingCastle.exe --help

HEALTHCHECK NONE

ENTRYPOINT ["c:\\app\\PingCastle.exe"]
