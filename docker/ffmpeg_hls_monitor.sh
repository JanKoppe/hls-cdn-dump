#!/bin/sh

FONT="/usr/share/fonts/liberation/LiberationMono-Regular.ttf"

set -eux

mkdir -p /tmp/data/public

ffmpeg -y -analyzeduration 3000000 -i $SOURCE \
  -nostats -loglevel repeat+level -r 25 \
  -filter_complex \
 "[0:a:0]ebur128=video=1:meter=18:target=-16[native][native_a]; [native_a]anullsink; \
  [0:a:0]showvolume=r=50:w=640:h=20:b=0:ds=log:dm=1.0[native_vu]; \
  [0:v:0]scale=h=-2:w=640[preview]; \
  [preview][native_vu][native]vstack=inputs=3[full_mix];[full_mix]framerate=fps=10[slowmix];[slowmix]format=yuv420p[out]; \
  [out]drawtext=fontfile=$FONT:text=${OVERLAY:-nix}:fontcolor=white:fontsize=40:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)-100[out_overlay]" \
  -map "[out_overlay]" -map "0:a:0" \
  -g 20 \
  -c:v libx264 -preset ultrafast -crf 25 -c:a aac -b:a 96k \
  -f hls -hls_key_info_file /tmp/data/hls.keyinfo -hls_time 6 -hls_list_size 10 -master_pl_publish_rate 5 -hls_flags +delete_segments+append_list+omit_endlist+independent_segments+temp_file+periodic_rekey -hls_allow_cache 0 \
  -hls_start_number_source epoch -strftime 1 -hls_segment_filename "/tmp/data/public/monitor-%Y%m%d-%s.ts" "/tmp/data/public/monitor.m3u8"
