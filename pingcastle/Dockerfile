# Set the base image
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1809 AS base
#FROM mcr.microsoft.com/windows/nanoserver:1809
FROM mcr.microsoft.com/windows/servercore:1809
#FROM mcr.microsoft.com/windows:10.0.19042.1469
WORKDIR /app
EXPOSE 80

# test download
RUN wget -Uri https://github.com/vletoux/pingcastle/releases/download/2.10.1.0/PingCastle_2.10.1.0.zip -UseBasicParsing


