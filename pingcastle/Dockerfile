# For Windows images, the base os version has to match the container os version
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
ARG ARCHIVE_URL=https://github.com/vletoux/pingcastle/releases/download/

# download
#RUN wget -Uri https://github.com/vletoux/pingcastle/releases/download/2.10.1.0/PingCastle_2.10.1.0.zip -UseBasicParsing
#RUN powershell -Command Invoke-WebRequest -Method Get -Uri ${ARCHIVE_URL}${BUILD_VERSION}/PingCastle_${BUILD_VERSION}.zip -OutFile c:\pingcastle.zip
RUN powershell -Command \
	Invoke-WebRequest -Method Get -Uri https://github.com/vletoux/pingcastle/releases/download/3.2.0.1/PingCastle_3.2.0.1.zip -OutFile c:\app\pingcastle.zip ; \
	Expand-Archive -Path c:\app\pingcastle.zip -DestinationPath c:\app ; \
	Remove-Item c:\app\pingcastle.zip -Force

#RUN dir
RUN dir c:\app

# validation
RUN c:\app\pingcastle.exe

#RUN Expand-Archive -Path c:\pingcastle.zip -DestinationPath c:\
#RUN Remove-Item c:\python-3.5.1.exe -Force

HEALTHCHECK NONE

CMD ["c:\app\pingcastle.exe"]
