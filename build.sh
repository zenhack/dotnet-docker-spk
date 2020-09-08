#!/usr/bin/env sh
mkdir -p /opt/app
cd /opt/app

export DOTNET_ROOT=/opt/dotnet
export PATH="$PATH:$DOTNET_ROOT"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
dotnet new webApp -o myWebApp --no-https --force
