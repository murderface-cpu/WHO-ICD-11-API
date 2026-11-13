#!/bin/sh
# Runs during `docker build`: starts the ICD-API once so it downloads and indexes
# the ICD-11 release into $TMPDIR, then stops it. The data ends up baked into the image.
set -e
cd /usr/share/icdapi
mkdir -p "$TMPDIR" analytics
export ASPNETCORE_ENVIRONMENT=container
export containerId=$(cat /usr/share/icdapi/containerId)

./ICD-API --urls http://127.0.0.1:80 > /tmp/preload.log 2>&1 &
PID=$!

RELEASE="${include%%_*}"
URL="http://127.0.0.1:80/icd/release/11/${RELEASE}/mms/search?q=diabetes"
for i in $(seq 1 360); do
  if wget -q -O /dev/null --header="API-Version: v2" --header="Accept-Language: en" \
       --header="Accept: application/json" "$URL"; then
    echo "ICD-11 ${include} preloaded after $((i*5))s"
    kill $PID; wait $PID 2>/dev/null || true
    rm -f "$TMPDIR"/clr-debug-pipe-* "$TMPDIR"/dotnet-diagnostic-* /usr/share/icdapi/logapi*.txt
    ls -la "$TMPDIR"
    exit 0
  fi
  if ! kill -0 $PID 2>/dev/null; then echo "ICD-API exited during preload"; cat /tmp/preload.log; exit 1; fi
  sleep 5
done
echo "Timed out preloading"; tail -50 /tmp/preload.log; exit 1
