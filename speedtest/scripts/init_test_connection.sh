#!/bin/bash
set -euo pipefail

FILE="/app/speedtest/test_connection.log"
# --include
# --no-progress-meter instead of --silent, not available in debian buster (has curl 7.64 but needs 7.67)
CURLOPTS=(
  "--silent"
  "--fail"
  "--location"
  "--max-time" 1
  "--retry" 1
  "--retry-delay" 1
)
TEST_INTERVAL=${TEST_INTERVAL:-5}

while true 
do 
  TIMESTAMP=$(date '+%s')

  # this is speedtest.py, not the binary from speedtest.net
  /app/speedtest/speedtest-cli --json --secure > "$FILE"
  # options for speedtest.net binary
  #/app/speedtest/speedtest-cli --format=json-pretty --progress=no > "$FILE"

  PING="$(jq -r '.ping' < "$FILE")"
  UPLOAD="$(jq -r '.upload' < "$FILE")"
  DOWNLOAD="$(jq -r '.download' < "$FILE")"
  # for speedtest.net
  #PING="$(jq -r '.ping.latency' < "$FILE")"
  #DOWNLOAD="$(jq -r '.upload.bandwidth' < "$FILE")"
  #UPLOAD="$(jq -r '.download.bandwidth' < "$FILE")"
  echo "Download: $DOWNLOAD Upload: $UPLOAD Ping: $PING   $TIMESTAMP"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "download,host=local value=$DOWNLOAD"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "upload,host=local value=$UPLOAD"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "ping,host=local value=$PING"
  sleep ${TEST_INTERVAL}
done
