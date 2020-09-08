#!/usr/bin/env sh

set -euo pipefail
export DOTNET_ROOT=/opt/app/publish
export COMPlus_EnableDiagnostics=0
export LD_PRELOAD=/opt/app/realpath.so
cd /opt/app/publish
strace ./myWebApp
