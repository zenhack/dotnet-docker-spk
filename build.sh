#!/usr/bin/env sh
set -euo pipefail
mkdir -p /opt/app/src
cd /opt/app/src

export DOTNET_ROOT=/opt/dotnet
export PATH="$PATH:$DOTNET_ROOT"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
dotnet new webApp -o myWebApp --no-https --force
cd myWebApp
dotnet publish \
	--runtime linux-musl-x64 \
	--output /opt/app/publish
