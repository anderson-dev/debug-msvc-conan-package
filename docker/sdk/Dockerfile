# escape=`

ARG WIN_VERSION='ltsc2019'
ARG DOTNET_SDK_VERSION='4.8'
FROM mcr.microsoft.com/dotnet/framework/sdk:${DOTNET_SDK_VERSION}-windowsservercore-${WIN_VERSION}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG GITVERSION_VERSION='5.6.10'
RUN dotnet tool install --global GitVersion.Tool --version "$env:GITVERSION_VERSION"

ENV chocolateyUseWindowsCompression false
RUN iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco feature disable --name showDownloadProgress; `
    choco install cmake --installargs "ADD_CMAKE_TO_PATH=System" -y; `
    choco install conan -y