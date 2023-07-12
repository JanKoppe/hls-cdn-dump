from alpine:3.17

run apk add --no-cache ffmpeg caddy supervisor curl openssl jq font-liberation
run curl https://packages.timber.io/vector/latest/vector-latest-x86_64-unknown-linux-musl.tar.gz --location --output vector.tar.gz && tar xzvf vector.tar.gz && mv vector-x86_64-unknown-linux-musl/bin/vector /bin/vector && rm -rf vector-x86_64-unknown-linux-musl && rm vector.tar.gz && mkdir -p /var/lib/vector/
add supervisord.conf /etc/supervisord.conf
add vector.yaml /etc/vector.yaml
add aes_key_rotator.sh /aes_key_rotator.sh
add ffmpeg_hls.sh /ffmpeg_hls.sh
add ffmpeg_hls_monitor.sh /ffmpeg_hls_monitor.sh
add Caddyfile /etc/Caddyfile
run mkdir -p /tmp/data/public
add public/* /tmp/data/public/
cmd ["supervisord", "-c", "/etc/supervisord.conf"]
