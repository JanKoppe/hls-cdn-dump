#!/bin/sh
set -eu
while true
do
    echo "writing new AES key"
    TMPFILE=$(mktemp)
    UNIXTS=$(date +%s)
    openssl rand 16 > "/tmp/data/public/hls_${UNIXTS}.key"
    echo "hls_${UNIXTS}.key"  > "${TMPFILE}" # URL for clients
    echo "/tmp/data/public/hls_${UNIXTS}.key" >> "${TMPFILE}" # Path for FFMPEG
    openssl rand -hex 16     >> "${TMPFILE}" # IV
    mv "${TMPFILE}" /tmp/data/hls.keyinfo # Atomic move in-place
    echo "done"
    sleep 15
done