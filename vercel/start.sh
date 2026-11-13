#!/bin/sh
# Runtime entrypoint: same as WHO's startICDAPI.sh, minus sshd and the spinner,
# and listening on $PORT (Vercel default 80).
cd /usr/share/icdapi
mkdir -p analytics 2>/dev/null || true
export ASPNETCORE_ENVIRONMENT="${ASPNETCORE_ENVIRONMENT:-container}"
export containerId=$(cat /usr/share/icdapi/containerId)
exec ./ICD-API --urls "http://0.0.0.0:${PORT:-80}"
