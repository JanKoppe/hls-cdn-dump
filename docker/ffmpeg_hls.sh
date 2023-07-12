#!/bin/sh

set -eux

INSPECT=$(ffprobe -print_format json -show_format -show_streams $SOURCE)

echo $INSPECT

FRAMERATE=$(echo $INSPECT | jq -r '.streams[] | select(.codec_type=="video") | .avg_frame_rate')

echo $FRAMERATE

mkdir -p /tmp/data/public

ffmpeg -y -analyzeduration 3000000 -i $SOURCE \
  -nostats -progress "/tmp/data/ffmpeg_progress" -loglevel repeat+level\
  -map 0:v:0 -map 0:a:0 \
  -map 0:v:0 -map 0:a:0 \
  -map 0:v:0 -map 0:a:0 \
  -map 0:v:0 -map 0:a:0 \
  -g $(($FRAMERATE * 2)) \
  -c:a:0 aac -ar:a:0 48000 -c:v:0 copy -b:a:0 128k \
  -c:v:1 libx264 -crf:v:1 ${CRF:-21} -c:a:1 aac -ar:a:1 48000 -preset:v:1 ${PRESET:-fast} -tune:v:1 ${TUNE:-film} -profile:v:1 ${PROFILE:-high} \
  -filter:v:1 scale=w=-2:h=720  -maxrate:v:1 3000k -bufsize:v:1 6000k  -b:a:1 128k \
  -c:v:2 libx264 -crf:v:2 ${CRF:-21} -c:a:2 aac -ar:a:2 48000 -preset:v:2 ${PRESET:-fast} -tune:v:2 ${TUNE:-film} -profile:v:2 ${PROFILE:-high} \
  -filter:v:2 scale=w=-2:h=540  -maxrate:v:2 2000k -bufsize:v:2 4000k  -b:a:2 96k \
  -c:v:3 libx264 -crf:v:3 ${CRF:-21} -c:a:3 aac -ar:a:3 48000 -preset:v:3 ${PRESET:-fast} -tune:v:3 ${TUNE:-film} -profile:v:3 ${PROFILE:-high} \
  -filter:v:3 scale=w=-2:h=360  -maxrate:v:3 800k  -bufsize:v:3 1600k   -b:a:3 64k \
  -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:540p v:3,a:3,name:360p" \
  -f hls -hls_key_info_file /tmp/data/hls.keyinfo -hls_time 6 -hls_list_size 10 -master_pl_publish_rate 5 -hls_flags +delete_segments+append_list+omit_endlist+independent_segments+temp_file+periodic_rekey -hls_allow_cache 0 \
  -hls_start_number_source epoch -strftime 1 -hls_segment_filename "/tmp/data/public/%v-%Y%m%d-%s.ts" \
  -master_pl_name "main_ffmpeg.m3u8" "/tmp/data/public/%v.m3u8" \
  -vf fps=0.1 -update 1 "/tmp/data/public/poster.jpg"
