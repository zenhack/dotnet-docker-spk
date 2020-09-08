#!/usr/bin/env sh

cd /opt/app
#export COREHOST_TRACE=1
export DOTNET_ROOT=/opt/dotnet
export PATH="$PATH:$DOTNET_ROOT"
export COMPlus_EnableDiagnostics=0
export LD_PRELOAD=/opt/app/realpath.so
#dotnet --info
strace dotnet run --project myWebApp
