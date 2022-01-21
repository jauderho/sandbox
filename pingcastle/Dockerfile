# Set the base image
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1809 AS base
#FROM mcr.microsoft.com/windows/nanoserver:1809
#FROM mcr.microsoft.com/windows/servercore:1809
#FROM mcr.microsoft.com/windows:10.0.19042.1469
#FROM mcr.microsoft.com/powershell:lts-nanoserver-1809
#FROM mcr.microsoft.com/powershell:lts-nanoserver-ltsc2022
FROM mcr.microsoft.com/powershell
#WORKDIR /app
#EXPOSE 80

ARG BUILD_VERSION
ARG ARCHIVE_URL=https://github.com/vletoux/pingcastle/releases/download/

# test download
#RUN wget -Uri https://github.com/vletoux/pingcastle/releases/download/2.10.1.0/PingCastle_2.10.1.0.zip -UseBasicParsing
#RUN powershell -Command Invoke-WebRequest -Method Get -Uri https://github.com/vletoux/pingcastle/releases/download/2.10.1.0/PingCastle_2.10.1.0.zip -OutFile c:\pingcastle.zip
RUN powershell -Command Invoke-WebRequest -Method Get -Uri ${ARCHIVE_URL}${BUILD_VERSION}/PingCastle_${BUILD_VERSION}.zip -OutFile c:\pingcastle.zip

RUN dir
#RUN Expand-Archive -Path c:\pingcastle.zip -DestinationPath c:\

#RUN Remove-Item c:\python-3.5.1.exe -Force

#CMD
