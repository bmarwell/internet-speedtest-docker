#!/bin/bash
set -euo pipefail

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
TEST_INTERVAL=${TEST_INTERVAL:-30}

measure_and_upload() {
  local timestamp
  local file
  local ping
  local upload
  local download

  file=$(mktemp)
  timestamp=$(date --utc '+%s')

  # this is speedtest.py, not the binary from speedtest.net
  /app/speedtest/speedtest-cli --json --secure > "$file"
  # options for speedtest.net binary
  #/app/speedtest/speedtest-cli --format=json-pretty --progress=no > "$FILE"

  ping="$(jq -r '.ping' < "$file")"
  upload="$(jq -r '.upload' < "$file")"
  download="$(jq -r '.download' < "$file")"
  # for speedtest.net
  #PING="$(jq -r '.ping.latency' < "$FILE")"
  #DOWNLOAD="$(jq -r '.upload.bandwidth' < "$FILE")"
  #UPLOAD="$(jq -r '.download.bandwidth' < "$FILE")"
  echo "Download: $download Upload: $upload Ping: $ping   $timestamp // " "$(LANG=en_US date -d @${timestamp})"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "download,host=local value=$download ${timestamp}000000000"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "upload,host=local value=$upload ${timestamp}000000000"
  curl "${CURLOPTS[@]}" 'http://db:8086/write?db=speedtest' --data-binary "ping,host=local value=$ping ${timestamp}000000000"

  rm -rf "$file"
}

while true; do 
  measure_and_upload &
  sleep ${TEST_INTERVAL}
done
