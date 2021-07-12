#!/usr/bin/env sh

set -euo pipefail
export DOTNET_ROOT=/opt/app/publish
export COMPlus_EnableDiagnostics=0
cd /opt/app/publish
strace ./myWebApp
